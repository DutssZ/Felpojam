extends Camera3D

@onready var pointer = $"../../../Pointer"

func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state
	
	var from = self.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + self.project_ray_normal(get_viewport().get_mouse_position()) * 2000
	
	var query = PhysicsRayQueryParameters3D.create(from, to, 2, [self])
	var result = space_state.intersect_ray(query)
	
	if result.has("position"):
		pointer.position = result["position"]
