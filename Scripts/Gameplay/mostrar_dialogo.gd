extends Node2D

func _ready():
	DialogueManager.show_dialogue_balloon(load("res://dialogs/Historia-principal/donde.dialogue"))
