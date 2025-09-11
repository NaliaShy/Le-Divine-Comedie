extends CharacterBody2D

@onready var anim = $Animaciones
@onready var hitbox = $AttackHitbox   # Área del ataque
@export var speed: float = 200.0
@export var attack_damage: int = 10
var is_attacking: bool = false
var is_dead: bool = false   # <- nuevo estado para controlar muerte

# --- Vida del personaje ---
var max_health := 100
var health := 100
@onready var health_bar = $HealthBar # Referencia de la barra dentro del jugador

func _ready():
	update_health_bar()

func _physics_process(delta: float) -> void:
	if is_dead:   # <- si está muerto no hace nada más
		return

	var input_vector = Vector2.ZERO

	# --- Movimiento con teclas ---
	if not is_attacking:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()

	# --- Ataque ---
	if Input.is_action_just_pressed("attack") and not is_attacking and input_vector == Vector2.ZERO:
		is_attacking = true
		velocity = Vector2.ZERO
		anim.play("simple-attack")

	# --- Movimiento ---
	if not is_attacking:
		velocity = input_vector * speed
	move_and_slide()

	# --- Animaciones ---
	if not is_attacking:
		if input_vector == Vector2.ZERO:
			anim.play("idle")
		else:
			anim.play("walk")
			anim.flip_h = input_vector.x < 0  # Voltea según dirección

# --- Señal: cuando termina la animación ---
func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "simple-attack":
		is_attacking = false
		if velocity.length() > 0:
			anim.play("walk")
		else:
			anim.play("idle")
	elif anim.animation == "death" and is_dead:
		# Cuando termina la animación de muerte -> game over
		get_tree().change_scene_to_file("res://Scenes/UI/game_over.tscn")

# --- Señal: cuando cambia de frame ---
func _on_animaciones_sprite_frames_changed() -> void:
	if anim.animation == "simple-attack":
		if anim.frame == 2:
			hitbox.monitoring = true
		else:
			hitbox.monitoring = false

func _on_attack_hitbox_area_entered(area: Area2D) -> void:
	print("⚡ Dante golpeó algo:", area.name)  
	if area.name == "HurtBox":
		var enemigo = area.get_parent()
		if enemigo.has_method("take_damage"):
			print("💥 Dante le quita vida a", enemigo.name)
			enemigo.take_damage(attack_damage)

# --- Funciones de vida ---
func take_damage(amount:int):
	if is_dead:  # <- no recibe más daño si ya murió
		return
	health -= amount
	health = clamp(health, 0 , max_health)
	update_health_bar()
	if health <= 0:
		die()

func heal(amount:int):
	if is_dead:
		return
	health += amount
	health = clamp(health,0,max_health)
	update_health_bar()

func update_health_bar():
	health_bar.value = health

func die():
	is_dead = true
	velocity = Vector2.ZERO
	anim.play("death")   # <- aquí usa tus frames "death"
