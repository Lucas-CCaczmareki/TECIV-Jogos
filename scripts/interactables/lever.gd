extends Area2D
class_name Lever

signal toggled(is_on: bool)

enum State { OFF, ON }
enum Trigger {
	INTERACT, # jogador perto aperta a tecla de interação (comportamento original)
	HIT,      # só é acionada por golpe (take_damage). Puzzle 2: golpe do lobo
}

@export var state: State = State.OFF
@export var trigger: Trigger = Trigger.INTERACT
@export var off_animation: StringName = &"disable"
@export var on_animation: StringName = &"enable"
@export var initial_off_animation: StringName = &"default"

var _player: Node2D
var _input_down := false

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _prompt: Label = $InteractionPrompt

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_set_initial_visual()
	_update_prompt()
	set_process_unhandled_input(trigger == Trigger.INTERACT)

# --- contrato com o PuzzleController ---

func is_active() -> bool:
	return state == State.ON

func reset_puzzle() -> void:
	set_active(false)

func set_active(value: bool) -> void:
	var new_state := State.ON if value else State.OFF
	if state == new_state:
		return
	state = new_state
	_update_visual()
	toggled.emit(value)

# Contrato de dano do TDD 05: golpe do lobo (ou qualquer ataque que alcance a
# layer da alavanca) alterna o estado. A layer/mask do Hitbox do lobo decide
# quem consegue acertar.
func take_damage(_amount: float) -> void:
	if trigger == Trigger.HIT:
		set_active(state == State.OFF)

func _unhandled_input(event: InputEvent) -> void:
	# Guarda o pressionamento para não repetir enquanto E estiver segurado.
	if event.is_action_pressed("interact") and not event.is_echo():
		if not _input_down:
			_input_down = true
			if _player != null:
				set_active(state == State.OFF)
				get_viewport().set_input_as_handled()
	elif event.is_action_released("interact"):
		_input_down = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player = body
		_update_prompt()

func _on_body_exited(body: Node2D) -> void:
	if body == _player:
		_player = null
		_update_prompt()

func _update_visual() -> void:
	var animation := on_animation if state == State.ON else off_animation
	if _animated_sprite.sprite_frames.has_animation(animation):
		_animated_sprite.play(animation)

func _set_initial_visual() -> void:
	var animation := on_animation if state == State.ON else initial_off_animation
	if not _animated_sprite.sprite_frames.has_animation(animation):
		return

	_animated_sprite.animation = animation
	_animated_sprite.stop()
	_animated_sprite.frame = (
		_animated_sprite.sprite_frames.get_frame_count(animation) - 1
		if state == State.ON else 0
	)

func _update_prompt() -> void:
	_prompt.visible = _player != null and trigger == Trigger.INTERACT
	
func _draw() -> void:
	if OS.is_debug_build():
		draw_line(Vector2(-30, 0), Vector2(30, 0), Color.RED, 2.0)
