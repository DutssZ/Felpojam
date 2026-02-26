extends Control

var isInGame = false
var ui_Animation_Playing := false

const position_away = 1080.0
@export var transition_time = 0.5

# Modificar o cursor!!
# if Cursor and Cursor.has_method("play_hide"):
#	await Cursor.play_hide(duration)
@export var Cursor: Node2D

@onready var fade = $Fade

@onready var titleMenu = $"Menu Inicial"
@onready var titleMenu_backButtonPos = $"Menu Inicial/HBoxContainer/VBoxContainer/HBoxContainer/Sair".get_viewport_transform()


@onready var configMenu = $"Configurações"
@onready var achieveMenu = $"Conquistas"
@onready var creditsMenu = $"Créditos"
@onready var menus_backButtonPos = $"Configurações/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/Voltar".position

@onready var exitMenu = $"Saída"
@onready var exitMenu_backButtonPos = $"Saída/MarginContainer/Voltar Saída".position

@onready var pauseMenu = $"Pause"
@onready var pauseMenu_backButtonPos = $Pause/HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/Continuar.position


@onready var feedbackIco = $"Feedback"
@onready var feedbackIcoMesh = $Feedback/FeedbackStamp
var feedbackTween
var feedbackIcoTex = ["Jogar", "Configuracoes", "Conquistas", "Creditos", "Sair", "Retornar"]
var feedbackIcoCol = [Color(0.333, 0.552, 0.838),Color(0.395, 0.576, 0.226),Color(0.859, 0.719, 0.278),
Color(0.877, 0.302, 0.495),Color(0.811, 0.259, 0.209),Color(0.8, 0.459, 0.165)]

@onready var activemenu = titleMenu
@onready var to = titleMenu

func _ready() -> void:
	ChangeMenu()
	print(titleMenu_backButtonPos)

func _input(event: InputEvent) -> void:
	print(event.is_action_pressed("Pause") && activemenu == null && !ui_Animation_Playing)
	if (event.is_action_pressed("Pause") && activemenu == null && !ui_Animation_Playing):
		get_tree().paused = true
		play_enter_anim(pauseMenu, pauseMenu)
		activemenu = pauseMenu
		
	if (event.is_action_pressed("ui_cancel") && activemenu != null && !ui_Animation_Playing):
		match activemenu:
			titleMenu:
				_on_sair_pressed(false)
			configMenu, achieveMenu, creditsMenu:
				_on_voltar_pressed(false)
			exitMenu:
				_on_voltar_saída_pressed(false)
			pauseMenu:
				_on_continuar_pressed(false)

##Menu Inicial
func _on_jogar_pressed() -> void:
	play_feedback_stamp(get_viewport().get_mouse_position(), 0)
	activemenu.hide()
	activemenu = null
	isInGame = true

func _on_configurações_pressed() -> void:
	to = configMenu
	play_feedback_stamp(get_viewport().get_mouse_position(), 1)
	FadePlay()

func _on_conquistas_pressed() -> void:
	to = achieveMenu
	play_feedback_stamp(get_viewport().get_mouse_position(), 2)
	FadePlay()

func _on_créditos_pressed() -> void:
	to = creditsMenu
	play_feedback_stamp(get_viewport().get_mouse_position(), 3)
	FadePlay()

func _on_sair_pressed(showStamp : bool = true) -> void:
	activemenu = exitMenu
	if(showStamp): play_feedback_stamp(get_viewport().get_mouse_position(), 4)
	play_enter_anim(exitMenu.botao, exitMenu)


##Configurações
func _on_tela_cheia_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) 

## Menus Geral
func _on_voltar_pressed(showStamp: bool = true) -> void:
	to = LandingMenu()
	if(showStamp): play_feedback_stamp(get_viewport().get_mouse_position(), 5)
	FadePlay()

## Saída
func _on_confirmar_sair_pressed() -> void:
	get_tree().quit()

func _on_voltar_saída_pressed(showStamp : bool = true) -> void:
	activemenu = titleMenu
	if(showStamp): play_feedback_stamp(get_viewport().get_mouse_position(), 5)
	play_back_anim(exitMenu.botao, exitMenu)

## Pause

func _on_continuar_pressed(showStamp : bool = true) -> void:
	if(showStamp): play_feedback_stamp(get_viewport().get_mouse_position(), 0)
	play_back_anim(pauseMenu, pauseMenu)
	activemenu = null
	isInGame = true
	get_tree().paused = false

func _on_terminar_jogo_pressed() -> void:
	play_feedback_stamp(get_viewport().get_mouse_position(), 5)
	get_tree().paused = false
	get_tree().reload_current_scene()

## Metodos
	
func ChangeMenu():
	if (activemenu != null): activemenu.hide()
	activemenu = to
	if (activemenu != null): activemenu.show()
	
func LandingMenu():
	if (isInGame): return pauseMenu
	else: return titleMenu


func _on_fade_blackout() -> void:
	feedbackIco.hide()
	ChangeMenu()
func _on_fade_fade_ended() -> void:
	ui_Animation_Playing = false

## Animações

func FadePlay():
	if !fade.playing:
		ui_Animation_Playing = true
		
		var tween := create_tween()
		tween.tween_interval(0.3)
		tween.tween_callback(func(): fade.play())

func play_enter_anim(objeto, menu):
	ui_Animation_Playing = true
	var tween := create_tween()
	
	menu.show()
	tween.tween_property(objeto, "position:y",position_away, 0)
	tween.tween_property(objeto, "position:y",0,transition_time).set_ease(Tween.EASE_OUT). set_trans(Tween.TRANS_SINE)
	tween.tween_callback(func(): ui_Animation_Playing = false)

func play_back_anim(objeto, menu):
	ui_Animation_Playing = true
	var tween := create_tween()
	
	
	tween.tween_property(objeto, "position:y",position_away,transition_time).set_ease(Tween.EASE_IN). set_trans(Tween.TRANS_SINE)
	tween.tween_callback(func(): menu.hide())
	tween.tween_callback(func(): ui_Animation_Playing = false)

func play_feedback_stamp(pos: Vector2, event):
	if (feedbackTween != null): feedbackTween.kill()
	
	feedbackIcoMesh.texture = ResourceLoader.load("res://source/assets/interface/feedback_stamp/2000px " + feedbackIcoTex[event] + ".png")
	feedbackIcoMesh.modulate.r = feedbackIcoCol[event].r
	feedbackIcoMesh.modulate.g = feedbackIcoCol[event].g
	feedbackIcoMesh.modulate.b = feedbackIcoCol[event].b
	
	feedbackIcoMesh.modulate.a = 1.0
	var rot = randf_range(-20,20)
	
	feedbackIcoMesh.rotation_degrees = rot
	feedbackIco.position = pos
	feedbackIco.show()
	
	feedbackTween = create_tween()
	feedbackTween.tween_property(feedbackIcoMesh, "scale", Vector2(0,0), 0.)
	feedbackTween.tween_property(feedbackIcoMesh, "scale", Vector2(1.2,1.2), 0.03)
	feedbackTween.tween_property(feedbackIcoMesh, "scale", Vector2(1,1), 0.01)
	feedbackTween.tween_interval(0.3)
	feedbackTween.tween_property(feedbackIcoMesh, "modulate:a", 0.0, 1.0)
	
