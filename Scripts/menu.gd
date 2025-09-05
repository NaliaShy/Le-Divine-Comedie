extends Control

@onready var save_manager = preload("res://scripts/save_manager.gd").new()
@onready var nombre_popup = $PopupPanel
@onready var nombre_input = $PopupPanel/LineEdit

var niveles := {
	1: "res://escenas/Limbo.tscn"
}

func _on_nueva_partida_pressed() -> void:
	# Mostrar el popup para pedir el nombre
	nombre_popup.popup_centered()

func _on_aceptar_pressed() -> void:
	var nombre = nombre_input.text.strip_edges()
	if nombre == "":
		nombre = "Jugador" # valor por defecto si no escribe nada

	# Guardamos el nombre y nivel inicial
	save_manager.player_data = {
		"nombre": nombre,
		"nivel": 1
	}
	save_manager.save_game()

	# Cambiamos a la primera escena
	get_tree().change_scene_to_file(niveles[1])

func _on_opciones_pressed() -> void:
	pass

func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_acceptar_pressed() -> void:
	var nombre = $PopupPanel/VBoxContainer/LineEdit.text.strip_edges()
	
	if nombre == "":
		# Si no escribe nada, puedes mostrar un aviso
		$PopupPanel/VBoxContainer/Label.text = "Escribe un nombre válido"
		return
	
	# Guardamos el nombre en el save_manager
	save_manager.player_data = {
		"nivel": 1,
		"nombre": nombre
	}
	save_manager.save_game()
	
	# Cerramos el popup y pasamos al primer mapa
	$PopupPanel.hide()
	get_tree().change_scene_to_file(niveles[1])
