extends Node2D
class_name WeaponPivot

var target: Vector2

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# ficam no process por que a posição do pivot e target mudam
	var pivot_pos: Vector2 = get_global_position()
	var direction: Vector2 = target - pivot_pos # destiny - origin
	var angle = atan2(direction.y, direction.x)
	set_rotation(angle)
	
	# inverte o pivot no eixo y (vertical) pro sprite apontar pro lugar certo
	# TODO: não tenho a mínima ideia de pq -3, mas se trocar quebra. Arrumar depois
	if target.x < pivot_pos.x:
		scale.y = -3
	else:
		scale.y = 3

func set_aim(point: Vector2) -> void:
	target = point
