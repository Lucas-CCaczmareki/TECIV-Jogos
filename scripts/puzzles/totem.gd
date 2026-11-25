extends Area2D
class_name Totem

# Totem do puzzle 3: ativa quando é atingido (laser da Sniper atravessa a fila).
# Segue o contrato de dano do TDD 05: "objetos feríveis implementam take_damage
# direto, como Area2D numa layer que a máscara do ataque alcance".
# Na cena: layer = enemy_hurtbox, pra cair na máscara das armas do jogador.

signal activated

@export var inactive_color := Color(0.45, 0.35, 0.3)
@export var active_color := Color(1.0, 0.8, 0.25)

var _active := false

func _ready() -> void:
	monitoring = false # só é detectado
	queue_redraw()

func take_damage(_amount: float) -> void:
	activate()

func activate() -> void:
	if _active:
		return
	_active = true
	queue_redraw()
	activated.emit()

func is_active() -> bool:
	return _active

# Chamado pelo PuzzleController quando a janela de tempo estoura
func reset_puzzle() -> void:
	_active = false
	queue_redraw()

# PLACEHOLDER visual até existir sprite
func _draw() -> void:
	var color := active_color if _active else inactive_color
	draw_rect(Rect2(-8, -28, 16, 36), color)
	draw_rect(Rect2(-8, -28, 16, 36), Color.BLACK, false, 1.0)
