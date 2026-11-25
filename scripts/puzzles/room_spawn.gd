extends Marker2D
class_name RoomSpawn

# Ponto de spawn de uma Room. Colocar como filho da Room e configurar no Inspector:
# cena do inimigo, em qual onda nasce e o atraso (TDD 11, "Ciclo de uma Room").

@export var scene: PackedScene
@export_range(0, 20) var wave: int = 0
@export_range(0.0, 10.0, 0.1) var delay: float = 0.0
