extends Path2D
class_name MovingPlatform

# Plataforma de madeira do canal de esgoto (puzzle 1). Estrutura da cena:
#   MovingPlatform (Path2D, este script)
#   └ PathFollow2D
#     └ Body (AnimatableBody2D: permite a colisão e carrega o jogador)
#       ├ CollisionShape2D (forma física da plataforma)
#       ├ Polygon2D        (visual placeholder)
#       └ RideZone (Area2D) detecta quem está em cima
#
# Como o jogo é top-down e o CharacterBody2D do jogador não é carregado sozinho,
# a plataforma soma o próprio deslocamento a quem está na RideZone.
# O SewerHazard pergunta `carries(body)` pra saber se o jogador está seguro.
#
# Desenhe o trajeto editando a curva do Path2D no editor (pontos A e B).

@export var speed: float = 40.0
@export var end_pause: float = 0.6 # espera nas pontas, ajuda o jogador a embarcar

@onready var _follow: PathFollow2D = $PathFollow2D
@onready var _body: AnimatableBody2D = $PathFollow2D/Body
@onready var _ride_zone: Area2D = $PathFollow2D/Body/RideZone

var _direction := 1.0
var _pause_left := 0.0

func _ready() -> void:
	add_to_group("sewer_platforms")
	_follow.loop = false
	_follow.rotates = false
	if curve == null or curve.point_count < 2:
		# trajeto padrão se esquecerem de desenhar: 96 px na horizontal
		curve = Curve2D.new()
		curve.add_point(Vector2.ZERO)
		curve.add_point(Vector2(96, 0))

func _physics_process(delta: float) -> void:
	if _pause_left > 0.0:
		_pause_left -= delta
		return

	var length := curve.get_baked_length()
	if length <= 0.0:
		return

	var before := _body.global_position
	_follow.progress = clampf(_follow.progress + _direction * speed * delta, 0.0, length)
	var moved := _body.global_position - before

	if is_zero_approx(_follow.progress) or is_equal_approx(_follow.progress, length):
		_direction = -_direction
		_pause_left = end_pause

	if moved != Vector2.ZERO:
		_carry_riders(moved)

func _carry_riders(moved: Vector2) -> void:
	for body in _ride_zone.get_overlapping_bodies():
		if body is CharacterBody2D:
			body.global_position += moved

## true se o corpo está em cima da plataforma
func carries(body: Node2D) -> bool:
	return _ride_zone.overlaps_body(body)
