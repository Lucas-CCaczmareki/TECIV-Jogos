extends Area2D
class_name Hurtbox

# recebe ataques no lugar do corpo (o corpo só colide com o mapa)
# não conhece o dono: só avisa por signal (chama pra baixo, avisa pra cima)
signal damaged(amount: float)
signal knockback_requested(impulse: Vector2)

func _ready() -> void:
	monitoring = false # só é detectada, não detecta ninguém

# mesmo contrato do TDD 05: o ataque checa has_method("take_damage")
func take_damage(amount: float) -> void:
	damaged.emit(amount)

func apply_knockback(impulse: Vector2) -> void:
	knockback_requested.emit(impulse)
