@abstract
class_name AbstractAttack
extends Node3D

signal hit(target: Node3D)

@export var Cooldown := 5.0
@export var Damage := 10.0

var owner_enemy: AbstractEnemy
var _waiting_cooldown := false


func trigger() -> void:
	if _waiting_cooldown or not can_attack():
		return
	_waiting_cooldown = true
	execute()
	await get_tree().create_timer(Cooldown).timeout
	_waiting_cooldown = false


@abstract
func execute() -> void
@abstract
func can_attack() -> bool


func set_owner_enemy(new_owner: AbstractEnemy) -> void:
	owner_enemy = new_owner
