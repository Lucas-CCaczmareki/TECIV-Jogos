# directional_sprite.gd (no nó AnimatedSprite2D de cada um)
extends AnimatedSprite2D
class_name DirectionalSprite

var facing: String = "down"

# aim = pra onde o personagem olha (mouse no Player, movimento no lobo)
func update_facing(aim: Vector2) -> void:
	if aim == Vector2.ZERO:
		return
	if abs(aim.y) >= abs(aim.x):
		facing = "up" if aim.y < 0 else "down"
	else:
		facing = "right" if aim.x > 0 else "left"

func play_move(moving: bool) -> void:
	play(("walk_" if moving else "idle_") + facing)

func play_action(action: String) -> void:   # "dodge", "attack", "dash", "howl"...
	play(action + "_" + facing)
