extends Node3D

@onready var Background: MeshInstance3D = $StaticBody3D/Background
@onready var Light: Light3D = $DirectionalLight3D
@onready var Camera: Camera3D = $Camera3D

func shake_camera(intensity: float = 0.5) -> void:
	var tween = create_tween()
	var original_rotation = Camera.rotation_degrees
	
	# Tilt quickly
	tween.tween_property(
		Camera, "rotation_degrees:x", original_rotation.x - intensity, 0.06
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	# Bounce back
	tween.tween_property(
		Camera, "rotation_degrees:x", original_rotation.x, 0.35
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
