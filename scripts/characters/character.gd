extends CharacterBody2D
class_name Character

@onready var health: HealthComponent = $HealthComponent
@onready var stamina: StaminaComponent = $StaminaComponent
@export var base_speed: float = 200.0
var move_velocity: Vector2 = Vector2.ZERO # por padrão, vem sem movimento. Ai a classe especializada sobreescreve

var modifiers: Dictionary = {
	"ammo_mult": 1.0,
	"cooldown_mult": 1.0,
	"speed_mult": 1.0,
	"bond_mult": 1.0,
	"infinite_ammo": false,
	"infinite_stamina": false,
}

var knockback_velocity: Vector2 = Vector2.ZERO
@export var knockback_friction: float = 600.0 # atrito c/ o chao. pesado move -, leve move +
@export_range (0.0, 1.0) var knockback_resistance: float = 0.0   # 0 = 0% = normal, 1 = 100% = imune (bosses).

func _ready() -> void:
	# os filhos vão ser obrigados a chamar o super() aqui
	health.died.connect(_on_died)
	pass

func _physics_process(delta: float) -> void:
	_update_movement(delta) # filhos usam isso pra definir move_velocity
	_decay_knockback(delta)
	velocity = move_velocity + knockback_velocity # combina direçãos do vet de movimento e knockback (podem se anular ou somar)
	move_and_slide()

# método virtual, deve ser implementado pelos filhos
func _update_movement(_delta: float) -> void:
	pass

# getter que retorna o valor efetivo da speed
func get_speed() -> float:
	return base_speed * modifiers["speed_mult"]

# define "método virtual" que as classes filhas devem sobre-escrever
func _on_died() -> void:
	push_warning("does nothing. must be overwritten")
	
func take_damage(amount: int) -> void:
	health.take_damage(amount) # repassa pro componente de vida

# TODAS modificações (pra aplicar e pra voltar pro padrão) devem passar pelo set_modifier
# isso garante que os efeitos dos powerups são repassados pros componentes (nodos filhos)
func set_modifier(key: String, value) -> void:
	if not modifiers.has(key): # se a key colocada n existe
		push_warning("Modificador desconhecido: " + key)
		return
		
	modifiers[key] = value #seta o valor do modificar com o valor de entrada
	# avisa os filhos que são responsáveis por alguma lógica afetada pelo mod
	# ex: estamina infinita. Quando esse mod tá on tem que avisar o StaminaComponent
	match key:
		"infinite_stamina":
			# se o filho tem stamina (NOT NULL), atualiza
			if stamina: stamina.infinite = value
		# ir acoplando os novos casos aqui

### Sistema de KNOCKBACK	
func apply_knockback(impulse: Vector2) -> void:
	# 1.0 (100%) - o quanto diminui(X% ex 40%)
	# se fizesse direto * o qnt diminui, ele moveria 40% só, não 60%.
	knockback_velocity = impulse * (1.0 - knockback_resistance)
	
# helper
func _decay_knockback(delta: float) -> void:
	## de.move_toward(para, passo)
	# quer ir pro 0,0 por que é um empurrao que para em algum momento
	# delta faz isso ser por frames.
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_friction * delta)
	
