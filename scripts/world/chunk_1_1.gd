extends Node2D

# TEASER (depois apaga)
@export var slime_scene: PackedScene
@export var companion_scene: PackedScene
var teaser_sprite: AnimatedSprite2D
var teaser_timer: float = 0.0
var attack_duration: float = 0.0
var companion: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: no futuro, agrupar todos os markers sobre um nó
	# pra organizar melhor. Se achar necessário (ai muda o jeito q esse for funciona)
	for child in get_children():
		if child.name.begins_with("SlimePosition"):
			var slime: Node2D = slime_scene.instantiate()
			add_child(slime)
			slime.global_position = child.global_position
	
	companion = companion_scene.instantiate()
	add_child(companion)
	companion.global_position = $CompanionPosition.global_position
	companion.follows_player = false
	
	companion.set_physics_process(false)   # para de seguir o player
	teaser_sprite = companion.get_node("AnimatedSprite2D")
	teaser_sprite.play("stop_left")
	
	var sf := teaser_sprite.sprite_frames
	attack_duration = sf.get_frame_count("attack_left") / sf.get_animation_speed("attack_left")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	teaser_timer += delta
	if teaser_timer >= 3.0:
		teaser_timer = 0.0
		teaser_sprite.play("attack_left")
		await get_tree().create_timer(attack_duration).timeout
		teaser_sprite.play("stop_left")
