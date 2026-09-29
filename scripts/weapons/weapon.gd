extends Node2D
class_name Weapon

@export var capacity: int = 10
var ammo: int = capacity

@export var fire_cooldown: float = 0.0
var fire_cooldownTimer: float = 0.0

@export var reload_cooldown: float = 0.0 #time reloading after pressing 'R'
var reload_cooldownTimer: float = 0.0

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

var blocked_by_dodge: bool = false
var blocked_by_reload: bool = false # ainda preciso implementar a funcionalidade de reload
var blocked_by_cooldown: bool = false

# signals
signal ammo_changed(current: int, max: int)
signal reload_started(duration: float)
#signal reload_finished()

func set_visibility(visibility: bool) -> void:
	visible = visibility

func _reload() -> void:
	if blocked_by_reload or ammo == capacity:
		return # does nothing
	blocked_by_reload = true
	reload_cooldownTimer = reload_cooldown
	print("entrei signal")
	reload_started.emit(reload_cooldown)

# only initiates if triggered by pressing 'R'
func _reload_cooldown(delta: float) -> void:
	if blocked_by_reload:
		reload_cooldownTimer -= delta
		if reload_cooldownTimer <= 0:
			ammo = capacity
			ammo_changed.emit(ammo, capacity)
			blocked_by_reload = false
	pass

# procedure
func _fire_cooldown(delta: float) -> void:
	if blocked_by_cooldown:
		fire_cooldownTimer -= delta
		if fire_cooldownTimer <= 0:
			blocked_by_cooldown = false

func _can_fire() -> bool:
	# depois vai empilhando os blockeds com or
	# dessa maneira a própria arma gerencia o disparo
	return (not (blocked_by_dodge or blocked_by_reload or blocked_by_cooldown)) and ammo > 0

func fire() -> void:
	print("does nothing. must be overwritten")
