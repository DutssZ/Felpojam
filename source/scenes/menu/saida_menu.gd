extends Control

const position_away = 1080.0
@onready var botao = $"MarginContainer/VBoxContainer/HBoxContainer/Confirmar Sair"

func _ready() -> void:
	botao.position.y = position_away
