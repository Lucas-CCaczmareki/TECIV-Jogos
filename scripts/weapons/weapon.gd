extends Node2D
class_name Weapon

# isso vai ter que mudar, precisa achar o dono
@onready var wielder: CharacterBody2D

var atk_sfx: AudioStreamPlayer
@export var atk_scene: PackedScene
@export var atk_cooldown: float = 0.0
var atk_cooldownTimer: float = 0.0

@export var damage: float = 0.0
@export var knockback: float = 0.0

var blocked_by_action: bool = false
var blocked_by_cooldown: bool = false

func _ready() -> void:
	pass

func set_visibility(visibility: bool) -> void:
	visible = visibility

# procedure
func _atk_cooldown(delta: float) -> void:
	if blocked_by_cooldown:
		atk_cooldownTimer -= delta
		if atk_cooldownTimer <= 0:
			blocked_by_cooldown = false

func _can_atk() -> bool:
	# depois vai empilhando os blockeds com or (nas subclasses)
	# dessa maneira a própria arma gerencia o disparo
	return (not (blocked_by_action or blocked_by_cooldown))

func atk() -> void:
	print("does nothing. must be overwritten")
