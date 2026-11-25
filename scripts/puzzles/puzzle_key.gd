extends Area2D
class_name PuzzleKey

# Chave do puzzle 1. Elemento do PuzzleController: emite `activated` ao ser pega.
#
# Diferente do ItemCollidable, NÃO dá queue_free(): o controller guarda a referência
# do elemento e descarta nós inválidos, então a chave só some da tela e desliga a
# detecção. Quem pega: só o jogador (o lobo não coleta).
# Layer/mask vêm da cena (layer interactable, mask player).

signal activated
signal collected(actor: Node)

var _collected := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	queue_redraw()

func is_active() -> bool:
	return _collected

# Chamado por PuzzleController.reset_puzzle(): a chave volta pro lugar
func reset_puzzle() -> void:
	_collected = false
	show()
	set_deferred("monitoring", true)

func _on_body_entered(body: Node2D) -> void:
	if _collected or not body.is_in_group("player"):
		return
	_collected = true
	hide()
	set_deferred("monitoring", false) # signal de física: não mexer em estado direto
	collected.emit(body)
	activated.emit()
