extends RangedWeapon
class_name PlayerWeapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	ammo_changed.emit(ammo, capacity)

	# conecta as funções que vão escutar os signals
	# nesse caso foi usada uma lambda (função anônima). func(): <código>
	wielder.dodge_started.connect(func(): blocked_by_action = true)
	wielder.dodge_ended.connect(func(): blocked_by_action = false)

func _process(delta: float) -> void:
	_atk_cooldown(delta) # 'delta' is the elapsed time since the previous frame.
	_reload_cooldown(delta)
	
	if Input.is_action_pressed("fire") and _can_atk():
		atk()
	
	if Input.is_action_just_pressed("reload"):
		_reload() #activate the cooldown to reload and set ammo
