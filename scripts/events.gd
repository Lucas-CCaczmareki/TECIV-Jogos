extends Node

# Esse script/node é um barramento global de evento
# SOMENTE signals, n vai ter estado nem lógica
# Os signals vão carregar dados, e não referências à nós (pra algo acessar o dado)

@warning_ignore("unused_signal")
signal camera_bounds_changed(bounds: Rect2)

@warning_ignore("unused_signal")
signal chunk_changed(chunk_id: int) # pode mudar o argumento depois, caso prefira usar ids igual o nome. ex: (1, 1) (1, 0)
