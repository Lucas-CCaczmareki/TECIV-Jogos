extends Weapon

@export var bullet_scene: PackedScene
@export var pellets: int = 6
@export var spread_degrees: float = 20.0
@export var speed_variation: float = 0.15

@onready var tip: Marker2D = $Tip
@onready var fire_sfx: AudioStreamPlayer = $FireSound

# chama quando instancia
func _init() -> void:
	capacity = 8
	fire_cooldown = 1.0
	reload_cooldown = 3.0
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	ammo_changed.emit(ammo, capacity)
	
	# conecta as funções que vão escutar os signals
	# nesse caso foi usada uma lambda (função anônima). func(): <código>
	player.dodge_started.connect(func(): blocked_by_dodge = true)
	player.dodge_ended.connect(func(): blocked_by_dodge = false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_fire_cooldown(delta) # 'delta' is the elapsed time since the previous frame.
	_reload_cooldown(delta)
	
	if Input.is_action_just_pressed("fire") and _can_fire():
		fire()
	
	# TODO: reload has to be equivalent to how many bullets you can put 
	# ex: ammo is 6/8, so the reload time is just for 2 bullets
	if Input.is_action_just_pressed("reload"):
		_reload() #activate the cooldown to reload and set ammo
	
func fire() -> void:
	fire_sfx.play()
	for i in pellets:
		var bullet: Node2D = bullet_scene.instantiate()
		var half_deg: float = spread_degrees / 2.0
		var bullet_offset: float = deg_to_rad(randf_range(-half_deg, half_deg))
		
		# Faz o sprite da bala nascer na ponta da arma
		bullet.global_position = tip.global_position
		
		# rotacionado de acordo com a arma + rotação de 10 graus pra cima ou 10 pra baixo da bullet
		# simulando comportamento das balas de uma doze
		bullet.global_rotation = global_rotation + bullet_offset
		
		# faz cada bala ter uma velocidade levemente diferente
		# ex de 0.75 (mais lenta) até 1.15 (mais rápida)
		bullet.speed *= randf_range(1.0 - speed_variation, 1.0 + speed_variation)
		
		get_tree().current_scene.add_child(bullet)
		
	ammo = ammo - 1
	ammo_changed.emit(ammo, capacity)
	
	# blocks the next fire
	blocked_by_cooldown = true
	fire_cooldownTimer = fire_cooldown
