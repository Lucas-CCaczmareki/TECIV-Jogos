extends Area2D
class_name Hitbox

@export var damage: float = 1.0
@export var knockback: float = 0.0

var _already_hit: Array[Area2D] = []

func _ready() -> void:
	# monitorable diz se a área é detectada por outras (layer)
	monitorable = false # só detecta, não é detectada
	
	# monitoring diz se a área detecta outras áreas (mask)
	monitoring = false  # nasce desligada
	area_entered.connect(_on_area_entered)


# enable e disable funcionam como os "ataques" da hitbox
func enable() -> void:
	_already_hit.clear()
	set_deferred("monitoring", true)

func disable() -> void:
	set_deferred("monitoring", false)

# essa parte processa o ataque em si (causa dano/knockback)
# se ela tá monitoring(chamou enable()), ela vai triggar o signal e chamar essa função
func _on_area_entered(area: Area2D) -> void:
	if area in _already_hit:
		return
	if not area.has_method("take_damage"):
		return
	_already_hit.append(area)
	area.take_damage(damage)
	if knockback > 0.0 and area.has_method("apply_knockback"):
		area.apply_knockback(global_position.direction_to(area.global_position) * knockback)

# utilizada quando o inimigo dá dano contínuo por contato. (ou seja, a área já ta dentro da hitbox)
func hit_overlapping_areas() -> void:
	_already_hit.clear()

	for area in get_overlapping_areas():
		_on_area_entered(area)
