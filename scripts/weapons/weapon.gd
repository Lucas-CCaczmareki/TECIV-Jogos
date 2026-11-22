extends Node2D
class_name Weapon

# ==============================================================================
# AJUSTES (editáveis no Inspector)
# ==============================================================================
@export var atk_scene: PackedScene
@export var tip: Marker2D
@export var atk_cooldown: float = 0.0
@export var damage: float = 0.0
@export var knockback_force: float = 0.0
@export var automatic: bool = true # true: segurar btn repete atk, false: 1 atk por clique

@onready var wielder: CharacterBody2D
@onready var sprite: Sprite2D

var atk_sfx: AudioStreamPlayer
var reload_sfx: AudioStreamPlayer
var atkInstance: Node2D
var atk_cooldownTimer: float = 0.0
#var blocked_by_action: bool = false # se tornou desnecessário. Dono gerencia bloqueios simplesmente NÃO chamando try atk
var blocked_by_cooldown: bool = false
var target_mask: int = 0

func _ready() -> void:
	pass
	
func setup(new_wielder: CharacterBody2D, new_target_mask: int) -> void:
	wielder = new_wielder
	target_mask = new_target_mask

func set_visibility(visibility: bool) -> void:
	visible = visibility

# isso instancia o atk dentro do Projectiles do World (evita q a bala suma se o dono morrer)
func _spawn_atk(attack: Node2D) -> void:
	var parent := get_tree().get_first_node_in_group("projectiles")
	if parent == null:
		parent = get_tree().current_scene # fallback pra testar com cena isolada
	parent.add_child(attack)

# procedure
func _atk_cooldown(delta: float) -> void:
	if blocked_by_cooldown:
		atk_cooldownTimer -= delta
		if atk_cooldownTimer <= 0:
			blocked_by_cooldown = false

func _can_atk() -> bool:
	# depois vai empilhando os blockeds com or (nas subclasses)
	# dessa maneira a própria arma gerencia o disparo (quando esse é solicitado pelo dono)
	return not blocked_by_cooldown

# o dono chama isso. A arma só valida e ataca
func try_attack() -> void:
	if _can_atk():
		atk()

func atk() -> void:
	print("does nothing. must be overwritten")
