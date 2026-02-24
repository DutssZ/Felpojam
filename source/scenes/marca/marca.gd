extends Node3D

@export var FadeTime := 5.0
@onready var Sprite: Sprite3D = $Sprite3D

func _ready() -> void:
	visible = false


func set_image(image: Texture2D) -> void:
	Sprite.texture = image

func spawn(pos: Vector3) -> void:
	position = pos
	
	var tween = create_tween()
	tween.tween_property(Sprite, "modulate:a", 0.0, FadeTime)
	tween.tween_callback(func(): self.queue_free())
