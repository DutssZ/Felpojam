@abstract
class_name AbstractEnemy
extends CharacterBody3D

signal enemy_died(id: String)

@export var Name := "Default"
@export var Health: float = 100.0
@export var Size: float = 1.0
@export var Movement_Speed: float = 3.0

@onready var Sprite: Sprite3D = $Sprite3D
@onready var Collision: CollisionShape3D = $CollisionShape3D

var Player: CharacterBody3D

enum State { MOVE, ATTACK, HIDE }
var state := State.MOVE


func _ready() -> void:
	Sprite.scale *= Size
	Collision.scale *= Size
	setup()

func _physics_process(delta: float) -> void:
	match state:
		State.MOVE: tick_move(delta)
		State.ATTACK: tick_attack(delta)
		State.HIDE: tick_hide(delta)


@abstract
func setup() -> void
@abstract
func tick_move(delta: float) -> void
@abstract
func tick_attack(delta:float) -> void
@abstract
func tick_hide(delta: float) -> void


func set_player(player: CharacterBody3D) -> void:
	Player = player

func take_damage(amount: float) -> void:
	Health -= amount
	if Health <= 0.0:
		die()

func die() -> void:
	enemy_died.emit(Name)
	queue_free()
