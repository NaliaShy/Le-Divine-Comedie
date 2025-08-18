extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@export var speed: float = 200.0
var is_attacking: bool = false

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO

	# --- Movimiento con teclas ---
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# --- Ataque ---
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		anim.play("attack")

	# --- Movimiento normal ---
	velocity = input_vector * speed
	move_and_slide()

	# --- Animaciones ---
	if is_attacking:
		# Mientras ataca, no cambiar a walk/idle, pero se puede mover
		pass
	else:
		if input_vector == Vector2.ZERO:
			anim.play("idle")
		else:
			anim.play("walk")
			anim.flip_h = input_vector.x < 0  # Voltea según dirección

# --- Señal de animación terminada ---



func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		is_attacking = false
		anim.play("idle")
