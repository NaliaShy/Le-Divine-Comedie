extends Node

var save_path := "user://savegame.json"

# Datos del jugador (ejemplo)
var player_data := {
	"nivel": 1,
	"posicion": Vector2.ZERO
}

# Guardar en archivo
func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(player_data))
		file.close()
		

# Cargar desde archivo
func load_game():
	if not FileAccess.file_exists(save_path):
		return false  # No hay partida guardada
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var result = JSON.parse_string(content)
	if typeof(result) == TYPE_DICTIONARY:
		player_data = result
		return true
	return false
