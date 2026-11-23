extends Node2D
class_name EnemyHealthBar

@onready var bar: ProgressBar = $ProgressBar

func setup(component: HealthComponent) -> void:
	#print("HealthBar: ", component.health, "/", component.max_healdth)
	component.health_changed.connect(_on_health_changed)
	_on_health_changed(component.health, component.max_health)
	
	

func _on_health_changed(current: int, maximum: int) -> void:
	bar.max_value = maximum
	bar.value = current	
	#print("Health: ", current, "/", maximum,
		#" | Bar: ", bar.value, "/", bar.max_value)
