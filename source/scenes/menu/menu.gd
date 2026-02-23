extends Control
var isInGame = false

@onready var fade = $Fade

@onready var titleMenu = $"Menu Inicial"
@onready var configMenu = $"Configurações"
@onready var achieveMenu = $"Conquistas"
@onready var creditsMenu = $"Créditos"


@onready var activemenu = titleMenu
@onready var to = titleMenu

func _ready() -> void:
	ChangeMenu()

##Menu Inicial
func _on_jogar_pressed() -> void:
	activemenu.hide()
	

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
	get_tree().quit()
	#pass # Replace with function body.

##Configurações
func _on_tela_cheia_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) 
	pass # Replace with function body.

func _on_voltar_pressed() -> void:
	to = titleMenu
	FadePlay()


func FadePlay():
	if !fade.playing:
		fade.play()
	
func ChangeMenu():
	activemenu.hide()
	activemenu = to
	activemenu.show()
	


func _on_fade_blackout() -> void:
	ChangeMenu()
