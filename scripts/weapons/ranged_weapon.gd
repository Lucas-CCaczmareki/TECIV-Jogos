extends Weapon
class_name RangedWeapon

@onready var reload_sfx: AudioStreamPlayer = $ReloadSound

var ammo: int
@export var capacity: int
@export var bullets_per_shot: int
@export var spread_degrees: float
@export var speed_variation: float
@export var tip: Marker2D

@export var reload_cooldown: float = 0.0 #time reloading after pressing 'R'
var reload_cooldownTimer: float = 0.0

var blocked_by_reload: bool = false

# signals
signal ammo_changed(current: int, max: int)
signal reload_started(duration: float)
#signal reload_finished()

func _ready() -> void:
	super()
	atk_sfx = $FireSound
	ammo = capacity

func _reload() -> void:
	if reload_sfx:
		reload_sfx.play()
	
	if blocked_by_reload or ammo == capacity:
		return # does nothing
	blocked_by_reload = true
	reload_cooldownTimer = reload_cooldown
	reload_started.emit(reload_cooldown)

# only initiates if triggered by pressing 'R'
# ou no caso de inimigos, pela munição ter acabado
func _reload_cooldown(delta: float) -> void:
	if blocked_by_reload:
		reload_cooldownTimer -= delta
		if reload_cooldownTimer <= 0:
			ammo = capacity
			ammo_changed.emit(ammo, capacity)
			blocked_by_reload = false
	pass

func _can_atk() -> bool:
	# sobre escreve a função, fica mais simples de ler
	return (not (blocked_by_action or blocked_by_reload or blocked_by_cooldown)) and ammo > 0
	
