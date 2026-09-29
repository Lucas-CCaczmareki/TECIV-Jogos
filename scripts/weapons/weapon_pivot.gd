extends Node2D
class_name WeaponPivot

# ill need to understand the logic and method to rotate a node
# next steps is to study this and then try to program
# @onready var weapon_sprite: Sprite2D = $Weapon
@export var weapon_scene: PackedScene
var weapon: Node2D

func _ready() -> void:
	equip_weapon()
	pass

func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var pivot_pos: Vector2 = get_global_position()
	var direction: Vector2 = mouse_pos - pivot_pos # destiny - origin
	var angle = atan2(direction.y, direction.x)
	set_rotation(angle)
	
	# inverte o pivot no eixo y (vertical) pro sprite apontar pro lugar certo
	if mouse_pos.x < pivot_pos.x:
		scale.y = -3
	else:
		scale.y = 3

func equip_weapon() -> void:
	# placeholder por eqnaunto; Ainda n tem sistema de trocar de arma
	# ainda precisa da free na arma atual de algum jeito
	weapon = weapon_scene.instantiate()
	add_child(weapon)
	pass

func get_weapon() -> Node2D:
	return weapon

# calls the visibility function for the active weapon
func set_weapon_visibility(visibility: bool) -> void:
	weapon.visible = visibility
