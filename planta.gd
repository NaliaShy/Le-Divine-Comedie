extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var detection_area = $Area2D   # área de detección

@export var attack_range: float = 100.0   # rango de ataque
@export var attack_cooldown: float = 1.5  # tiempo entre ataques
@export var damage: int = 15              # daño que hace
@export var max_health: int = 25          # vida máxima

var current_health: int = max_health
var is_attacking: bool = false
var target: Node2D = null
var can_attack: bool = true
var player_inside: bool = false

func _ready():
	current_health = max_health
	anim.play("hit") # idle por defecto

func _physics_process(delta: float) -> void:
	if not target:
		return

	var to_player = target.global_position - global_position
	var distance = to_player.length()

	if distance <= attack_range and not is_attacking and can_attack:
		start_attack(to_player)

# ---- ATAQUE ----
func start_attack(to_player: Vector2):
	is_attacking = true
	can_attack = false

	# elegir animación según el lado del jugador
	if to_player.x < 0:
		anim.play("left")
	else:
		anim.play("right")

# cuando termina la animación de ataque
func _on_animated_sprite_2d_animation_finished() -> void:
	print("🎬 Animación terminada: ", anim.animation)

	if anim.animation == "left" or anim.animation == "right":
		is_attacking = false
		if player_inside and target:
			if target.has_method("take_damage"):
				print("🌿 Planta ataca a Dante → daño: ", damage)
				target.take_damage(damage)

		# cooldown antes de volver a atacar
		if player_inside:
			await get_tree().create_timer(attack_cooldown).timeout
			start_attack(target.global_position - global_position)
		else:
			anim.play("hit") # vuelve a idle

# ---- DETECCIÓN ----
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Dante":  # o usa grupo "player"
		target = body
		player_inside = true
		print("👀 Dante detectado por la planta")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == target:
		player_inside = false
		print("👋 Dante salió del rango")

# ---- VIDA ----
func take_damage(amount: int) -> void:
	current_health -= amount
	print("💥 Planta recibe ", amount, " de daño. Vida restante: ", current_health)

	if current_health <= 0:
		die()

func die():
	print("☠️ Planta eliminada!")
	queue_free()
