extends Node3D

@export_group("Configurações")
@export var disable_screenshake := false

@export_group("Nodes")
@export var Player: CharacterBody3D
@export var Carimbo: Node3D
@export var World: Node3D

const Marca = preload("res://source/scenes/marca/marca.tscn")

# Signals
func _on_carimbo_ground_stamped(carimbo_transform: Transform3D, carimbo_resource: CarimboResource) -> void:
	var image = carimbo_resource.CarimboImage
	var intensity = carimbo_resource.Dano / 10.0
	
	var pos = carimbo_transform.origin
	var size = carimbo_transform.basis.get_scale().length()
	
	if not disable_screenshake:
		World.shake_camera(intensity)
	
	var marca = Marca.instantiate()
	add_child(marca)
	marca.set_size(size)
	marca.set_image(image)
	marca.spawn(pos)
