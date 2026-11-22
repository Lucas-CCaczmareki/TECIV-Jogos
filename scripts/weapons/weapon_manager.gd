extends Node2D
class_name WeaponManager

# @onready var weapon_sprite: Sprite2D = $Weapon
@export_flags_2d_physics var target_mask: int
@export var weapon_scenes: Array[PackedScene]
@export var weapon_pivot: WeaponPivot
@export var max_slots: int = 2

var active_weapon: Weapon
var weapons: Array[Weapon] = [] # começa vazio, significa todas as armas possuídas
var slots: Array[Weapon] = [] # aqui vão só as armas equipadas.
var active_weapon_idx: int = 0

# envia a ref da weapon ativa
signal weapon_changed(weapon: Weapon)

func _ready() -> void:
	for scene in weapon_scenes:
		var w: Weapon = scene.instantiate()
		w.setup(get_parent(), target_mask)
		weapons.append(w)
	
	# pra mudar as armas equipadas agr na fase de teste basta inverter a ordem do weapon_scenes no inspector
	for i in mini(max_slots, weapons.size()):
		slots.append(weapons[i])
	
	if not slots.is_empty(): active_weapon = slots[0]
	weapon_pivot.add_child(active_weapon)
	emit_signal("weapon_changed", active_weapon)
	pass

func _process(_delta: float) -> void:
	weapon_pivot.set_aim(get_global_mouse_position())
	# TODO: eu preciso bloquear a troca de arma se o cara tiver recém instanciando uma atkscene
	# tem um bug que a atk scene nunca é liberada se eu fizer isso
	if Input.is_action_just_pressed("switch_weapon"):
		switch_weapon();

func switch_weapon() -> void:
	if slots.size() < 2:
		return
	if active_weapon is RangedWeapon:
		active_weapon.cancel_reload()
	
	weapon_pivot.remove_child(active_weapon)
	active_weapon_idx = (active_weapon_idx + 1) % slots.size() # essa linha faz o papel de vetor circular w
	active_weapon = slots[active_weapon_idx]
	emit_signal("weapon_changed", active_weapon)
	weapon_pivot.add_child(active_weapon)
	active_weapon.set_visibility(true)

func get_weapon() -> Weapon:
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
