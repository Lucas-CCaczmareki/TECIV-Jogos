extends Node
class_name HealthComponent

@export var max_health: int = 100
var health: int
var shield: int = 0
var shield_duration: float = 0.0
var _died: bool = false 

# signals
signal health_changed(current: int, max: int)
signal shield_changed(current: int)
signal died

func _ready() -> void:
	health = max_health
	pass # Replace with function body.

func _process(delta: float) -> void:
	if shield <= 0: return 
	
	# processa a duração do shield somente se tem algum shield
	shield_duration -= delta
	if shield_duration <= 0.0:
		shield = 0 # zera o shield (n vai mais diminuir shield duration pq cai no 1o return)
		shield_duration = 0.0
		shield_changed.emit(shield)

func heal(amount: int) -> void:
	health = mini(health + amount, max_health)
	health_changed.emit(health, max_health)

func heal_percent(p: float) -> void:
	heal(roundi(max_health*p)) # manda o amount de % em int arredondado pro heal

func add_shield(amount: int, duration: float) -> void:
	shield += amount
	shield_changed.emit(shield)
	shield_duration += duration # adicionar mais shield aumenta a duração

func take_damage(amount: int) -> void:
	if _died: return # não processa dano em alguém q ta morto e ainda n foi liberado
	
	var remaining := amount
	if shield > 0:
		var absorbed := mini(shield, remaining)
		# se remaining for menor, ele é subtraindo de shield e shield fica com oq sobrou e remaining 0
		# a mesma lógica se aplica caso shield for o menor valor
		shield -= absorbed
		remaining -= absorbed
		
		if shield == 0:
			shield_duration = 0.0 # limpa a duração se o shield foi pro beleléu
		
		if remaining > 0: # se tem dano pra aplicar
			health = maxi(health - remaining, 0)
			health_changed.emit(health, max_health)
			
			if health == 0:
				_died = true
				died.emit()
