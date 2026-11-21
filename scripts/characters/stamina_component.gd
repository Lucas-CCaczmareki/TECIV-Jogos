extends Node
class_name StaminaComponent

# usa float pq gasta stamina por segundo, ent * delta vai dar ~0.16
@export var max_stamina: float = 100 # valor padrao pra n começar em 0
@export var regen_rate: float = 20.0 # regenera 20 pts/s
@export var regen_delay: float = 1.0 # segundos q o cara fica em "exaustão" sem gastar

var stamina: float
var _regen_cooldown: float = 0.0
var infinite: bool = false

signal stamina_changed(current: float, max: float)
signal depleted # significa q zerou a estamina

func _ready() -> void:
	stamina = max_stamina

# esse component precisa do process pra conseguir autoregenerar a barra de estamina
# como o comportamento é igual pra todos q tiverem stamina... (só mudando valores)
func _process(delta: float) -> void:
	# conta o delay antes de começar a regenerar stamina
	if _regen_cooldown > 0.0:
		_regen_cooldown -= delta
		return
	
	if stamina < max_stamina:
		# minf retorna o menor float
		# process roda a cada frame, e o delta normaliza isso em segundos
		# ent fazer * delta me da quantos regen_rate pts por frame seriam em 1 segundo
		stamina = minf(stamina + regen_rate * delta, max_stamina)
		stamina_changed.emit(stamina, max_stamina)

func drain(rate: float, delta: float) -> bool:
	if infinite: return true
	if stamina <= 0.0: return false
	spend(minf(rate * delta, stamina)) # gasta o último tickzinho de stamina pra forçar emissão do depleted
	return stamina > 0.0

func spend(amount: float) -> bool:
	print("stamina: " + str(stamina))
	if infinite: return true # n gasta stamina
	
	if stamina < amount: return false
	stamina = maxf(stamina - amount, 0.0)
	
	# ativa o cooldown pra começar a regenerar stamina toda vez que consome
	_regen_cooldown = regen_delay
	stamina_changed.emit(stamina, max_stamina)
	
	if stamina == 0.0: # se acabou a stamina, 
		depleted.emit()

	return true
	
func reset() -> void:
	stamina = max_stamina
	_regen_cooldown = 0.0
	stamina_changed.emit(stamina, max_stamina)
