class_name Door
extends Interactable

signal opened
signal closed

@export var blocking_body_path: NodePath = ^"BlockingBody"

@export var blocking_body: StaticBody2D
@export var open_animation: StringName = &"open"
@export var closed_animation: StringName = &"closed"

## true: o jogador abre com a tecla de interação (comportamento original).
## false: começa trancada; só permite interação do jogador depois de unlock().
@export var player_can_open := true
## Começa aberta (ex.: porta de entrada de uma Room, que fecha quando a sala começa)
@export var start_open := false

var is_open := false
var is_unlocked := false

var _player: Node2D # só definido enquanto o player estiver na área
var _body_layer := 0 # collision do bloqueio, guardada pra restaurar no close()
var _body_mask := 0

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _interaction_prompt: Label = $InteractionPrompt

func _ready() -> void:
	blocking_body = get_node_or_null(blocking_body_path) as StaticBody2D
	if blocking_body == null:
		push_error("Door '%s' precisa de um blocking_body." % name)
	else:
		_body_layer = blocking_body.collision_layer
		_body_mask = blocking_body.collision_mask

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	set_process_unhandled_input(false) # só liga com o player por perto
	is_unlocked = player_can_open

	if start_open:
		_apply_state(true, false)
	else:
		enabled = is_unlocked
		if _animated_sprite.sprite_frames.has_animation(closed_animation):
			_animated_sprite.play(closed_animation)
	_update_prompt()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		interact(_player)

func open() -> void:
	if is_open:
		return
	_apply_state(true, true)
	opened.emit()

func close() -> void:
	if not is_open:
		return
	_apply_state(false, true)
	closed.emit()

func unlock() -> void:
	if is_unlocked:
		return
	is_unlocked = true
	enabled = not is_open
	set_process_unhandled_input(enabled and _player != null)
	_update_prompt()

func lock() -> void:
	is_unlocked = false
	if is_open:
		close()
	else:
		enabled = false
		set_process_unhandled_input(false)
		_update_prompt()

func interact(actor: Node) -> void:
	if not enabled or is_open:
		return

	super.interact(actor)
	open()

func _apply_state(open_state: bool, animate: bool) -> void:
	is_open = open_state
	enabled = is_unlocked and not open_state
	set_deferred("monitorable", not open_state)

	# open/close podem vir de um signal de física (placa, sala), então é deferred
	if blocking_body != null:
		blocking_body.set_deferred("collision_layer", 0 if open_state else _body_layer)
		blocking_body.set_deferred("collision_mask", 0 if open_state else _body_mask)

	_play_state_animation(open_state, animate)

	if open_state:
		_player = null
	else:
		reset_interaction() # pode ser aberta de novo
	set_process_unhandled_input(enabled and _player != null)
	_update_prompt()

func _play_state_animation(open_state: bool, animate: bool) -> void:
	var anim := open_animation if open_state else closed_animation
	var frames := _animated_sprite.sprite_frames
	if not frames.has_animation(anim):
		return
	if animate:
		_animated_sprite.play(anim)
	else:
		# aplica o estado final direto, sem tocar a animação
		_animated_sprite.animation = anim
		_animated_sprite.stop()
		_animated_sprite.frame = frames.get_frame_count(anim) - 1 if open_state else 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player = body
		set_process_unhandled_input(enabled)
		_update_prompt()

func _on_body_exited(body: Node2D) -> void:
	if body == _player:
		_player = null
		set_process_unhandled_input(false)
		_update_prompt()

func _update_prompt() -> void:
	if is_instance_valid(_interaction_prompt):
		_interaction_prompt.visible = enabled and _player != null
