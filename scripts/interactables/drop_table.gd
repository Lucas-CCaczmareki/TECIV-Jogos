extends Resource
class_name DropTable

@export var entries: Array[DropEntry] = []

func roll() -> PackedScene:
	# o total weight vai dar o "range" de pesos.
	# [0----------100] esse seria o range, por exemplo
	var total_weight: float = 0.0

	# somamos o peso de cada item, cada item nesse sentido "ocupa" um peso no range
	# ex: <itemA, 10> e <itemB, 90>
	# range [0-A-10------B------100]
	for entry in entries:
		total_weight += entry.weight

	# se o inimigo n droppa item, retorna nulo (nada)
	if total_weight <= 0.0:
		return null
	
	# escolhe um valor aleatório entre o range.
	# o randf() é um aleatório entre 0.0(0%) e 1.0(100%)
	# que vai dar uma posição de 0 até total_weight na barra
	# O que tem peso maior tem mais posições
	var random_weight := randf() * total_weight

	# esse é o percorrer pra escolher o item, por exemplo, se random_weight = 30
	# [0---A---10---------(30)---B-------10]
	# o 30 ta dentro do range do B (depois do A).
	for entry in entries:
		random_weight -= entry.weight
		if random_weight < 0.0:
			return entry.pickup_scene
	return null
