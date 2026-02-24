class_name Utils
extends Node

# https://www.rorydriscoll.com/2016/03/07/frame-rate-independent-damping-using-lerp/
## Frame-rate-independent lerp function. 
static func damp(source, target, smoothing: float, delta: float):
	assert(smoothing > 0 and smoothing < 1)
	assert(delta > 0)
	return lerp(source, target, 1.0 - pow(1.0 - smoothing, delta))


## Project the mouse position to a given plane above the ground
static func project_cursor_to_plane(viewport: Viewport, plane_height: float) -> Vector3:
	assert(viewport != null)
	var camera = viewport.get_camera_3d()
	var mouse_pos = viewport.get_mouse_position()
	
	# Ray origin and direction in world space
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_dir = camera.project_ray_normal(mouse_pos)
	
	# Intersect with the plane y = height
	# Parametric ray: P = ray_origin + t * ray_dir
	# We want P.y = height, so:
	# height = ray_origin.y + t * ray_dir.y
	# t = (height - ray_origin.y) / ray_dir.y

	if abs(ray_dir.y) < 0.001:
		return Vector3.ZERO  # Ray is parallel to the plane, no intersection

	var t = (plane_height - ray_origin.y) / ray_dir.y
	return ray_origin + t * ray_dir
