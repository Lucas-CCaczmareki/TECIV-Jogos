extends CanvasLayer

@export var ammo_hud_scene: PackedScene
var ammo_hud: Control
var _weapon: Weapon

func _ready() -> void:
	ammo_hud = ammo_hud_scene.instantiate()
	add_child(ammo_hud)

func _process(delta: float) -> void:
	pass
	
func bind_weapon(w: Weapon) -> void:
	# essa função é chamada através do sinal de troca de arma
	# quando troca, desconecta o sinal da instancia de arma anterior da hud
	# e conecta o signal da nova arma
	if _weapon and _weapon.ammo_changed.is_connected(ammo_hud._update_ammo):
		_weapon.ammo_changed.disconnect(ammo_hud._update_ammo)
	
	_weapon = w
	w.ammo_changed.connect(ammo_hud._update_ammo)
	ammo_hud._update_ammo(w.ammo, w.capacity)
	(ammo_hud.get_node("VBoxContainer/WeaponImg")).texture = (w.get_node("Sprite2D")).texture
