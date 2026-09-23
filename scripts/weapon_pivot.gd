extends Node2D

# ill need to understand the logic and method to rotate a node
# next steps is to study this and then try to program
@onready var weapon_sprite: Sprite2D = $Weapon

func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var pivot_pos: Vector2 = get_global_position()
	var direction: Vector2 = mouse_pos - pivot_pos # destiny - origin
	var angle = atan2(direction.y, direction.x)
	set_rotation(angle)
	
	if mouse_pos.x < pivot_pos.x:
		scale.y = -3
	else:
		scale.y = 3
