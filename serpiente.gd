extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var detection_area = $Area2D   # área de detección

@export var speed: float = 80.0            # Velocidad de vuelo
@export var attack_range: float = 40.0     # Distancia para atacar
@export var max_health: int = 20           # Vida máxima del murciélago
@export var attack_cooldown: float = 1.0   # Tiempo entre ataques

var current_health: int = max_health
var is_attacking: bool = false
var target: Node2D = null
var can_attack: bool = true

@export var patrol_distance: float = 100.0
var start_position: Vector2
var direction: int = 1
var player_inside: bool = false

func _ready():
	start_position = global_position
	current_health = max_health
	anim.play("walk")
func _physics_process(delta: float) -> void:
	if not target:
		return  # <- Evita el error hasta que encuentre un jugador
	var to_player = target.global_position - global_position
	var distance = to_player.length()
	if distance <= attack_range and not is_attacking and can_attack:
		start_attack()
	velocity = to_player.normalized() * speed
	if not is_attacking and anim.animation != "walk":
		anim.play("walk")
	move_and_slide()
	

	
func _on_animated_sprite_2d_animation_finished() -> void:
	print("⚡ Animación terminada: ", anim.animation)
	if anim.animation == "attack":
		is_attacking = false
		# Si el jugador sigue dentro, volver a atacar
		if player_inside and target:
			if target.has_method("take_damage"):
				print("💥 Murciélago ataca a Dante")
				target.take_damage(20) #Le quita 20 de vida al jugador
				#repetir ataque si aun esta cerca
		if player_inside:
			start_attack()
		else:
			anim.play("walk")
func start_attack():
	is_attacking = true
	anim.play("attack")
	


func _on_detectar_body_entered(body: Node2D) -> void:
	if body.name == "Dante":  # o usa un grupo para identificar al jugador
		target = body
		player_inside = true



func _on_detectar_body_exited(body: Node2D) -> void:
	if body == target:
		player_inside = false
		
func take_damage(amount: int) -> void:
	current_health -= amount
	print("💥 Enemigo recibe ", amount, " de daño. Vida restante: ", current_health)
	if current_health <= 0:
		die()

func die():
	print("☠️ Enemigo eliminado!")
	queue_free()
	
