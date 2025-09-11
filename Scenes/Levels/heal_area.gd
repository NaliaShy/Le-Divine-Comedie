extends Area2D

@export var heal_amount: int = 25   # cantidad de vida que cura

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node):
	if body.name == "Dante":  # aseguramos que es tu personaje
		body.heal(heal_amount)   # llama a la función que ya creaste
		queue_free()             # desaparece después de curar
