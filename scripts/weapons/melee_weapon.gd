extends Weapon
class_name MeleeWeapon

@export var max_combo: int
@export var combo_window: float
var combo_count: int = 1
var comboTimer: float = 0.0
var in_combo: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	_atk_cooldown(delta) # 'delta' is the elapsed time since the previous frame.
	
	if in_combo:
		#print(comboTimer)
		comboTimer -= delta
		if comboTimer <= 0:
			combo_count = 1
			comboTimer = 0
			in_combo = false
			
	if Input.is_action_just_pressed("fire") and _can_atk():
		atk()
		_combo_count()
		wielder.set_can_move(false) 
	pass

func _combo_count() -> void:
	# se entrou aqui significa que acertou um hit
	comboTimer = combo_window # inicia o timer
	in_combo = true
	
	#print(combo_count)
	
	if combo_count < max_combo: 
		combo_count += 1
	else:
		combo_count = 1 #começa em 1, 3 hits diferentes

func set_combo_count(value: int) -> void:
	combo_count = value
