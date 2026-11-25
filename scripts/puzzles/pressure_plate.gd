extends Area2D
class_name PressurePlate

# Placa de pressão: só fica ativa com algo em cima (jogador ou lobo).
# O controller usa `toggled` (true = pressionada). `pressed`/`released` são
# conveniência pra som e animação.
# Layer/mask vêm da cena (layer interactable, mask player + companion).

signal pressed
signal released
signal toggled(is_pressed: bool)

@export var pressed_color := Color(0.35, 0.85, 0.45)
@export var released_color := Color(0.55, 0.55, 0.6)

var _bodies: Array[Node2D] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	queue_redraw()

func is_active() -> bool:
	return not _bodies.is_empty()

# O estado da placa é físico (tem alguém em cima ou não), então não há o que resetar
func reset_puzzle() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body in _bodies:
		return
	var was_pressed := is_active()
	_bodies.append(body)
	if not was_pressed:
		_emit_state(true)

func _on_body_exited(body: Node2D) -> void:
	_bodies.erase(body)
	if _bodies.is_empty():
		_emit_state(false)

func _emit_state(value: bool) -> void:
	queue_redraw()
	if value:
		pressed.emit()
	else:
		released.emit()
	toggled.emit(value)

# PLACEHOLDER visual até existir sprite
func _draw() -> void:
	var color := pressed_color if is_active() else released_color
	draw_rect(Rect2(-14, -9, 28, 18), color)
	draw_rect(Rect2(-14, -9, 28, 18), Color.BLACK, false, 1.0)
