extends Node3D

# Exports
@export var Height := 1.0
@export var Scale := 0.25
@export var DefaultDuration := 1.5
@export_range(0.0, 1.0, 0.0001) var Smoothing := 0.9995

@export_group("Resource")
@export var CarimboConfig: CarimboResource

@export_group("Templates")
@export var TEMPLATES = {
	"Default" : "res://source/scenes/carimbo/templates/default_carimbo.tres",
}

@export_group("Nodes")
@export var Player: CharacterBody3D

# On ready
@onready var MeshCarimbo: MeshInstance3D = $Area3D/ScalePivot/MeshCarimbo
@onready var AreaCarimbo: Area3D = $Area3D
@onready var PivotCarimbo: Marker3D = $Area3D/ScalePivot
@onready var CooldownTimer: Timer = $CooldownTimer

# Signals
signal ground_stamped(position)

# Const
const RED := Color.LIGHT_CORAL
const GREEN := Color.LIGHT_GREEN
const DEFAULT_COLOR := Color(0.361, 0.188, 0.11)
const ALPHA := 0.5

# Variables
var is_falling: bool:
	set(new_value):
		if AreaCarimbo:
			AreaCarimbo.monitoring = new_value
		is_falling = new_value

var cursor_position: Vector3:
	set(new_value):
		if AreaCarimbo:
			AreaCarimbo.position = new_value
		cursor_position = new_value

var last_cooldown_duration := 0.0


# Built in 
func _ready() -> void:
	set_template("Default")
	cursor_position = get_area_position()
	is_falling = false
	CooldownTimer.one_shot = true
	AreaCarimbo.scale *= Scale


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Attack"):
		fall()
	elif CooldownTimer.time_left <= last_cooldown_duration:
		cursor_position = Utils.damp(
			cursor_position, get_area_position(), Smoothing, delta
		)
	set_material()

# Custom
func set_template(template: String) -> void:
	CarimboConfig = load(TEMPLATES[template])
	MeshCarimbo.mesh = CarimboConfig.CarimboMesh


func get_area_position() -> Vector3:
	if get_viewport() and get_viewport().get_camera_3d():
		return Utils.project_cursor_to_plane(get_viewport(), Height)
	else:
		return Vector3.ZERO

func set_material() -> void:
	var color: Color
	if is_falling:
		color = DEFAULT_COLOR
	elif CooldownTimer.time_left > 0:
		color = RED
		color.a = ALPHA
	elif cursor_position.distance_to(Player.position) > CarimboConfig.Alcance:
		color = RED
		color.a = ALPHA
	else:
		color = GREEN
		color.a = ALPHA
	
	MeshCarimbo.material_override.set("albedo_color", color)

func fall() -> void:
	if CooldownTimer.time_left > 0:
		return
	elif cursor_position.distance_to(Player.position) > CarimboConfig.Alcance:
		return
	
	var anim_duration = DefaultDuration * CarimboConfig.Velocidade
	var cooldown_duration = anim_duration + CarimboConfig.Cooldown
	
	is_falling = true
	last_cooldown_duration = CarimboConfig.Cooldown
	CooldownTimer.start(cooldown_duration)
	play_fall_animation(anim_duration)


func play_fall_animation(duration: float) -> void:
	var tween := create_tween()
	var pos = Vector3(cursor_position.x, 0.0, cursor_position.z)
	
	# -- Anticipation
	tween.tween_property(
		AreaCarimbo, "position:y", 1.3 * Height, duration * 0.1
		).set_ease(Tween.EASE_OUT). set_trans(Tween.TRANS_SINE)
	
	# -- Slam down
	tween.tween_property(
		AreaCarimbo, "position:y", 0.0, duration * 0.35
		).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	
	# Emit signal
	tween.tween_callback(func(): ground_stamped.emit(pos))
	
	# Squash
	tween.tween_property(
		PivotCarimbo, "scale", Vector3(1.5, 0.5, 1.5), 0.08
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	
	# -- Back up
	tween.tween_property(
		AreaCarimbo, "position:y", Height, duration * 0.55
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	
	tween.parallel().tween_property(
		PivotCarimbo, "scale", Vector3.ONE, duration * 0.47 
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	tween.tween_callback(func(): is_falling = false)
