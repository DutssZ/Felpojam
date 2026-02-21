extends CharacterBody2D

# Exports
@export_category("Movement")
@export var MAX_SPEED := 300.0
@export var DASH_SPEED := 600.0
@export var DASH_DURATION := 0.15
@export var DASH_COOLDOWN := 1.0
@export var SMOOTHING := 1000.0

@export_category("Nodes")
@export var SPRITE: AnimatedSprite2D
@export var DASH_TIMER: Timer


enum Direction {
	NORTHWEST = 0,
	NORTH = 1,
	NORTHEAST = 2,
	EAST = 3,
	SOUTHEAST = 4,
	SOUTH = 5,
	SOUTHWEST = 6,
	WEST = 7,
}

const IDLE_ANIMATIONS = [
	"Idle - NorthEast", "Idle - North", "Idle - NorthEast",
	"Idle - East", "Idle - SouthEast", "Idle - South",
	"Idle - SouthEast", "Idle - East"
] # According to directions

# Variables
var input_direction := Vector2(0, 0)
var input_is_dodge := false
var current_direction = Direction.SOUTH


func _ready() -> void:
	# Set default animation
	if not SPRITE.is_playing():
		SPRITE.play(IDLE_ANIMATIONS[Direction.SOUTH])


func _process(_delta: float) -> void:
	get_input()
	set_animation()


func _physics_process(delta: float) -> void:
	update_velocity(delta)
	move_and_slide()


func get_input() -> void:
	input_direction = Input.get_vector("Left", "Right", "Up", "Down").normalized()
	input_is_dodge = Input.is_action_pressed("Dodge")


func get_direction() -> void:
	if input_direction.length_squared() == 0:
		return
	
	var angle = input_direction.angle() / (PI/4) # From -3.. to 4
	angle = roundf(angle) # From -4 to 4
	angle = 4.0 if angle == -4.0 else angle # From -3 to 4
	angle += 3.0  # From 0 to 7
	
	current_direction = angle


func set_animation() -> void:
	get_direction()
	if input_direction.length_squared() != 0:
		SPRITE.flip_h = input_direction.x < 0
	SPRITE.play(IDLE_ANIMATIONS[current_direction])


func update_velocity(delta : float) -> void:
	# While dodging
	if DASH_TIMER.time_left >= DASH_COOLDOWN - DASH_DURATION:
		velocity = Utils.damp(velocity, input_direction * DASH_SPEED, SMOOTHING, delta)
		return
	
	# Start dodge
	if input_is_dodge and DASH_TIMER.is_stopped():
		DASH_TIMER.start(DASH_COOLDOWN)
		velocity = input_direction * DASH_SPEED
		return
	
	# Normal movement
	var input_vel = input_direction * MAX_SPEED
	velocity = velocity.limit_length(MAX_SPEED)
	velocity = Utils.damp(velocity, input_vel, SMOOTHING, delta)
