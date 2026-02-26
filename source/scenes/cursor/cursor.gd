extends Node2D

@export var MouseSpeed := 800.0
@export var MouseSize := 2.0

@onready var CursorSprite: Sprite2D = $Sprite2D
var mouse_pos := Vector2()

const pointer_image = preload("res://source/assets/interface/sample_cursor/1 cursor.png")
const cross_image = preload("res://source/assets/interface/sample_cursor/6 cancel.png")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	assert(CursorSprite != null)
	CursorSprite.scale = Vector2(MouseSize, MouseSize)
	set_image_cross(false)


func _process(delta: float) -> void:
	var mouse_input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	mouse_input *= MouseSpeed * delta
	if mouse_input != Vector2.ZERO:
		Input.warp_mouse(mouse_pos + mouse_input)
	
	CursorSprite.position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_pos = event.position


func set_image_cross(cross: bool = true) -> void:
	if cross:
		CursorSprite.texture = cross_image
	else:
		CursorSprite.texture = pointer_image


func play_hide(duration:float = 1.0):
	if CursorSprite.modulate.a == 0.0:
		return
		
	var tween = create_tween()
	
	tween.tween_property(
		CursorSprite, "modulate:a", 0.0, duration
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	
	return tween.finished


func play_show(duration:float = 1.0):
	if CursorSprite.modulate.a == 1.0:
		return
	
	var tween = create_tween()
	
	tween.tween_property(
		CursorSprite, "modulate:a", 1.0, duration*0.5
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	
	return tween.finished
