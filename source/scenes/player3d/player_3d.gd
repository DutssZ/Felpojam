extends CharacterBody3D

# Exports
@export_group("Movement")
@export var MAX_SPEED := 5.0
@export var DASH_SPEED := 15.0
@export var DASH_DURATION := 0.15
@export var DASH_COOLDOWN := 1.0
@export_range(0.0, 1.0, 0.0001) var SMOOTHING := 0.9995

# On ready
@onready var SPRITE: AnimatedSprite3D = $AnimatedSprite3D
@onready var DASH_TIMER: Timer = $DashTimer

# Enum
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

enum State {
	Idle,
	Run,
	Dash,
}

# Consts
const ANIM_DIRECTION = [
	"NorthEast", "North", "NorthEast",
	"East", "SouthEast", "South",
	"SouthEast", "East"
] # According to directions

# Variables
var input_direction := Vector2(0, 0)
var input_direction_3d := Vector3(0,0,0)
var input_is_dodge := false
var current_direction = Direction.SOUTH
var current_state = State.Idle

# Util
var is_dashing := false:
	get: return DASH_TIMER.time_left >= DASH_COOLDOWN - DASH_DURATION
const default_anim = "Idle - South"


# Built-in functions

func _ready() -> void:
	# Set default animation
	if not SPRITE.is_playing():
		SPRITE.play(default_anim)
	# Config timer
	DASH_TIMER.one_shot = true

func _process(_delta: float) -> void:
	get_input()
	get_direction()
	get_state()
	set_animation()

func _physics_process(delta: float) -> void:
	update_velocity(delta)
	move_and_slide()


# Custom functions

func get_input() -> void:
	input_direction = Input.get_vector("Left", "Right", "Up", "Down").normalized()
	input_direction_3d = (
		transform.basis * Vector3(input_direction.x, 0, input_direction.y)
		.normalized()
	)
	input_is_dodge = Input.is_action_pressed("Dodge")


func get_direction() -> void:
	if input_direction.length_squared() == 0:
		return
	
	var angle = input_direction.angle() / (PI/4) # From -3.. to 4
	angle = roundf(angle) # From -4 to 4
	angle = 4.0 if angle == -4.0 else angle # From -3 to 4
	angle += 3.0  # From 0 to 7
	
	current_direction = angle


func get_state() -> void:
	if is_dashing:
		current_state = State.Dash
	elif input_direction != Vector2.ZERO:
		current_state = State.Run
	else:
		current_state = State.Idle


func set_animation() -> void:
	if input_direction.length_squared() != 0:
		SPRITE.flip_h = input_direction.x < 0
	
	var anim_name = (
		State.keys()[current_state] + " - " + ANIM_DIRECTION[current_direction]
	)
	
	if SPRITE.sprite_frames.has_animation(anim_name):
		SPRITE.play(anim_name)
	else:
		SPRITE.play(default_anim)


func update_velocity(delta : float) -> void:
	# While dashing
	if is_dashing:
		velocity = Utils.damp(velocity, input_direction_3d * DASH_SPEED, SMOOTHING, delta)
		return
	
	# Start dodge
	if input_is_dodge and DASH_TIMER.is_stopped():
		DASH_TIMER.start(DASH_COOLDOWN)
		velocity = input_direction_3d * DASH_SPEED
		return
	
	# Normal movement
	velocity = velocity.limit_length(MAX_SPEED)
	velocity = Utils.damp(velocity, input_direction_3d * MAX_SPEED, SMOOTHING, delta)


# About shadows
# https://github.com/godotengine/godot/issues/58332
