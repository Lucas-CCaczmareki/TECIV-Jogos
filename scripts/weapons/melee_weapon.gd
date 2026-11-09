extends Weapon
class_name MeleeWeapon

@export var max_combo: int
@export var combo_window: float
var combo_count: int = 1
var comboTimer: float = 0.0
var in_combo: bool = false

func _ready() -> void:
	sprite = $Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	_atk_cooldown(delta) # 'delta' is the elapsed time since the previous frame.
	
	if in_combo:
		comboTimer -= delta
		if comboTimer <= 0:
			combo_count = 1
			comboTimer = 0
			in_combo = false
			
	if _atk_action() and _can_atk():
		atk()
		_combo_count()
		wielder.set_can_move(false) 
	pass

func _atk_cooldown(delta: float) -> void:
	if blocked_by_cooldown:
		atk_cooldownTimer -= delta
		if atk_cooldownTimer <= 0:
			blocked_by_cooldown = false
			
			# TODO: eu preciso padronizar se weapon q cuida de acabar a atk scene ou se a atk scene se tira da arvore mesmo
			atkInstance.queue_free()  
			wielder.set_can_move(true)


func _combo_count() -> void:
	# se entrou aqui significa que acertou um hit
	comboTimer = combo_window # inicia o timer
	in_combo = true
	
	if combo_count < max_combo: 
		combo_count += 1
	else:
		combo_count = 1 #começa em 1, 3 hits diferentes

func set_combo_count(value: int) -> void:
	combo_count = value
	
func _atk_action() -> bool:
	print("does nothing. must be overwritten")
	return false
