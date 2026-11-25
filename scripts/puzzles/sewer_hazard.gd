extends Area2D
class_name SewerHazard

# Canal de esgoto (puzzle 1). Área de morte instantânea, com duas exceções (TDD 11):
#   1. jogador no ar durante a esquiva  (player.airborne)
#   2. jogador sobre uma plataforma móvel (grupo "sewer_platforms")
# Morrer aqui NÃO é game over: o jogador volta ao `respawn_point`, o começo do desafio.
#
# A checagem é por frame (não por body_entered) porque o jogador pode entrar no
# canal no ar e aterrissar na água quando a janela do airborne acaba.
# Sem colisão física: é só uma Area2D (mask = layer do player).

signal player_fell(body: Node2D)

## Marker2D no começo do desafio (lado de onde o jogador parte)
@export var respawn_point: Marker2D
@export var hazard_enabled := true
@export var fill_color := Color(0.25, 0.55, 0.2, 0.45) # placeholder do visual

func _ready() -> void:
	if respawn_point == null:
		push_error("SewerHazard '%s' precisa de respawn_point." % name)
	queue_redraw()

func _physics_process(_delta: float) -> void:
	if not hazard_enabled or respawn_point == null:
		return
	for body in get_overlapping_bodies():
		if body.is_in_group("player") and not _is_safe(body):
			_send_back(body)

func _is_safe(body: Node2D) -> bool:
	if body.get("airborne") == true:
		return true
	for platform in get_tree().get_nodes_in_group("sewer_platforms"):
		if platform.carries(body):
			return true
	return false

func _send_back(body: Node2D) -> void:
	# encerra uma esquiva em andamento, senão ela empurra o jogador de volta pra água
	if body.get("is_dodging") == true and body.has_method("_end_dodge"):
		body.call("_end_dodge")
	body.global_position = respawn_point.global_position
	if "velocity" in body:
		body.velocity = Vector2.ZERO
	if "move_velocity" in body:
		body.move_velocity = Vector2.ZERO
	player_fell.emit(body)

# PLACEHOLDER visual: pinta o shape retangular até existir o tile do esgoto
func _draw() -> void:
	if not hazard_enabled:
		return
	for child in get_children():
		var shape_node := child as CollisionShape2D
		if shape_node and shape_node.shape is RectangleShape2D:
			var size: Vector2 = shape_node.shape.size
			draw_rect(Rect2(shape_node.position - size / 2.0, size), fill_color)
