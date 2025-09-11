extends CharacterBody2D

var triggered := false

func _on_radio_body_entered(body: Node2D) -> void:
	if body.name == "Dante" and not triggered:
		triggered = true
		DialogueManager.show_dialogue_balloon(
			load("res://dialogs/Historia-principal/virgilio.dialogue")
		)
