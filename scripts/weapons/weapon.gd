extends Node2D
class_name Weapon

@export var fire_cooldown: float = 0.0
var fire_cooldownTimer: float = 0.0

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

var blocked_by_dodge: bool = false
var blocked_by_reload: bool = false # ainda preciso implementar a funcionalidade de reload
var blocked_by_cooldown: bool = false

func set_visibility(visibility: bool) -> void:
	visible = visibility

# procedure
func _fire_cooldown(delta: float) -> void:
	if blocked_by_cooldown:
		fire_cooldownTimer -= delta
		if fire_cooldownTimer <= 0:
			blocked_by_cooldown = false

func _can_fire() -> bool:
	# depois vai empilhando os blockeds com or
	# dessa maneira a própria arma gerencia o disparo
	return not (blocked_by_dodge or blocked_by_reload or blocked_by_cooldown)

func fire() -> void:
	print("does nothing. must be overwritten")
