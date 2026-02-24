extends Node3D

@export var FadeDuration := 1.0
@export var FadeDelay := 5.0
@onready var Sprite: Sprite3D = $Sprite3D

func _ready() -> void:
	visible = false
	set_size()

func set_size(size: float = 1.0) -> void:
	Sprite.scale *= size

func set_image(image: Texture2D) -> void:
	Sprite.texture = image

func spawn(pos: Vector3) -> void:
	position = pos
	visible = true
	
	var tween = create_tween()
	tween.tween_property(
		Sprite, "modulate:a", 0.0, FadeDuration
		).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE).set_delay(FadeDelay)
		
	tween.tween_callback(func(): self.queue_free())
