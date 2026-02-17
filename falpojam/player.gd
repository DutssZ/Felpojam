extends CharacterBody3D

@export var speed = 5.0;
@export var MinAcceleration = 10.0;
@export var MaxAcceleration = 100.0;
var acceleration;

func _process(delta: float) -> void:
	
	var input = Input.get_vector("movement_west","movement_east","movement_north","movement_south")
	var moveDirection = Vector3(input.x,0,input.y)
	moveDirection = moveDirection.normalized()
	acceleration = lerp(MinAcceleration,MaxAcceleration,moveDirection.length())
	velocity = velocity.move_toward(moveDirection * speed, acceleration * delta)
	move_and_slide()
