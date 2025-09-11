extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var detection_area = $Area2D

@export var speed: float = 50.0
@export var patrol_distance: float = 100.0
@export var attack_range: float = 30.0  # distancia cuerpo a cuerpo
@export var max_health: int = 30       # vida máxima del enemigo

var current_health: int = max_health
var start_position: Vector2
var direction: int = 1
var is_attacking: bool = false
var target: Node2D = null
var player_inside: bool = false  # si Dante está dentro del área

func _ready():
	start_position = global_position
	current_health = max_health
	anim.play("walk")

func _physics_process(delta: float) -> void:
	# Si hay target y está dentro del área, intentar atacar
	if target and player_inside:
		var to_player = target.global_position - global_position
		if to_player.length() <= attack_range and not is_attacking:
			start_attack()
			return

	# Si está atacando, no se mueve
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Patrulla de ida y vuelta
	var target_x = start_position.x + patrol_distance * direction
	if (direction == 1 and global_position.x >= target_x) or (direction == -1 and global_position.x <= target_x):
		direction *= -1
	
	velocity.x = speed * direction
	move_and_slide()

	# Animación de caminar
	anim.play("walk")
	anim.flip_h = direction < 0

# Señal cuando termina la animación
func _on_AnimatedSprite2D_animation_finished() -> void:
	if anim.animation == "attack":
		is_attacking = false
		# Si el jugador sigue dentro, volver a atacar
		if player_inside and target:
			if target.has_method("take_damage"):
				target.take_damage(20) #Le quita 20 de vida al jugador
		#repetir ataque si aun esta cerca
		if player_inside:
			start_attack()
		else:
			anim.play("walk")

# Función para iniciar ataque
func start_attack():
	is_attacking = true
	anim.play("attack")

# Señales del área de detección
func _on_detectar_body_entered(body: Node2D) -> void:
	if body.name == "Dante":  # o usa un grupo para identificar al jugador
		target = body
		player_inside = true

func _on_body_exited(body: Node) -> void:
	if body == target:
		player_inside = false

# --- NUEVO: recibir daño desde Dante ---
func take_damage(amount: int) -> void:
	current_health -= amount
	print("💥 Enemigo recibe ", amount, " de daño. Vida restante: ", current_health)

	if current_health <= 0:
		die()

func die():
	print("☠️ Enemigo eliminado!")
	queue_free()
