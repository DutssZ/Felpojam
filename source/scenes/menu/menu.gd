extends Control

var isInGame = false
var ui_Animation_Playing = false

const position_away = 1080.0
@export var transition_time = 0.5

@onready var fade = $Fade

@onready var titleMenu = $"Menu Inicial"
@onready var configMenu = $"Configurações"
@onready var achieveMenu = $"Conquistas"
@onready var creditsMenu = $"Créditos"
@onready var exitMenu = $"Saída"

@onready var pauseMenu = $"Pause"


@onready var activemenu = titleMenu
@onready var to = titleMenu

var i = 0

func _ready() -> void:
	ChangeMenu()
	
func _process(delta: float) -> void:
	print(activemenu)
	print(i)
	i += 1

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("Pause") && activemenu == null && !ui_Animation_Playing):
		get_tree().paused = true
		play_enter_anim(pauseMenu, pauseMenu)
		activemenu = pauseMenu
		
	if (event.is_action_pressed("ui_cancel") && !ui_Animation_Playing):
		match activemenu:
			titleMenu:
				_on_sair_pressed()
			configMenu, achieveMenu, creditsMenu:
				_on_voltar_pressed()
			exitMenu:
				_on_voltar_saída_pressed()
			pauseMenu:
				_on_continuar_pressed()

##Menu Inicial
func _on_jogar_pressed() -> void:
	activemenu.hide()
	activemenu = null
	isInGame = true

func _on_configurações_pressed() -> void:
	to = configMenu
	FadePlay()

func _on_conquistas_pressed() -> void:
	to = achieveMenu
	FadePlay()

func _on_créditos_pressed() -> void:
	to = creditsMenu
	FadePlay()

func _on_sair_pressed() -> void:
	activemenu = exitMenu
	play_enter_anim(exitMenu.botao, exitMenu)


##Configurações
func _on_tela_cheia_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) 

## Menus Geral
func _on_voltar_pressed() -> void:
	to = LandingMenu()
	FadePlay()

## Saída
func _on_confirmar_sair_pressed() -> void:
	get_tree().quit()

func _on_voltar_saída_pressed() -> void:
	activemenu = titleMenu
	play_back_anim(exitMenu.botao, exitMenu)

## Pause

func _on_continuar_pressed() -> void:
	play_back_anim(pauseMenu, pauseMenu)
	activemenu = null
	isInGame = true
	get_tree().paused = false

func _on_terminar_jogo_pressed() -> void:
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
	ChangeMenu()
func _on_fade_fade_ended() -> void:
	ui_Animation_Playing = false

## Animações

func FadePlay():
	if !fade.playing:
		ui_Animation_Playing = true
		fade.play()

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
