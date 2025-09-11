extends Control
func _ready():
	$Button.pressed.connect(_on_retry_pressed)
	$Button2.pressed.connect(_on_exit_pressed)

# Reintentar → vuelve al primer mapa
func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Limbo.tscn")  # cambia por tu mapa inicial

# Salir → vuelve al menú principal
func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/menu.tscn")  # cambia por tu menú
