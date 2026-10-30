extends Node2D
class_name WeaponManager

# @onready var weapon_sprite: Sprite2D = $Weapon
@export var weapon_scenes: Array[PackedScene]
@export var weapon_pivot: WeaponPivot
const MAX_WEAPONS: int = 2

var active_weapon: Weapon
var weapons: Array[Weapon] = [] # começa vazio
var active_weapon_idx: int = 0

# envia a ref da weapon ativa
signal weapon_changed(weapon: Weapon)

func _ready() -> void:
	for scene in weapon_scenes:
		var w: Weapon = scene.instantiate()
		weapons.append(w)
	
	active_weapon = weapons[0]
	weapon_pivot.add_child(active_weapon)
	emit_signal("weapon_changed", active_weapon)
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch_weapon"):
		switch_weapon(active_weapon_idx + 1);

func switch_weapon(idx : int) -> void:
	# TODO: sistema simplificado pra 2 armas apenas. Usado pro teaser
	# precisa refinamento. Aqui só usa com index fixo
	if idx == MAX_WEAPONS:
		idx = 0; # simula um comportamento de vetor circular
		
	weapon_pivot.remove_child(active_weapon)
	active_weapon = weapons[idx]
	active_weapon_idx = idx
	emit_signal("weapon_changed", active_weapon)
	weapon_pivot.add_child(active_weapon)

func get_weapon() -> Node2D:
	return active_weapon

# calls the visibility function for the active weapon
func set_weapon_visibility(visibility: bool) -> void:
	active_weapon.visible = visibility

# the instances created does not go with the WeaponPivot automatically
# TODO: i should review this later
func _exit_tree() -> void:
	for w in weapons:
		if is_instance_valid(w) and not w.is_inside_tree():
			w.queue_free()
