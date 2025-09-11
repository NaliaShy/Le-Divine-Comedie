extends Control

@onready var save_manager = preload("res://scripts/save_manager.gd").new()
@onready var nombre_popup = $PopupPanel
@onready var nombre_input = $PopupPanel/VBoxContainer/LineEdit

var niveles := {
	1: "res://Scenes/Levels/Limbo.tscn"
}

func _on_nueva_partida_pressed() -> void:
	get_tree().change_scene_to_file(niveles[1])# Mostrar el popup para pedir el nombre


func _on_aceptar_pressed() -> void:


	# Guardamos el nombre y nivel inicial
	save_manager.player_data = {

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

	

	
	# Cerramos el popup y pasamos al primer mapa
	$PopupPanel.hide()
	
