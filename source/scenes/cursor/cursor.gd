extends Node2D

@export var MouseSpeed := 800.0
@export var MouseSize := 2.0

@onready var CursorSprite: Sprite2D = $Sprite2D
var mouse_pos := Vector2()


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	assert(CursorSprite != null)
	CursorSprite.scale = Vector2(MouseSize, MouseSize)


func _process(delta: float) -> void:
	var mouse_input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	mouse_input *= MouseSpeed * delta
	if mouse_input != Vector2.ZERO:
		Input.warp_mouse(mouse_pos + mouse_input)
	
	CursorSprite.position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_pos = event.position
