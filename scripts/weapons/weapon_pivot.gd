extends Node2D
class_name WeaponPivot

func _ready() -> void:
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
