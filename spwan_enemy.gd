extends Area2D
@onready var Enemy_Scene = load("res://Scenes/Enemies/murcielago.tscn")

var bool_spwan = true
var random = RandomNumberGenerator.new()
func _ready() -> void:
	random.randomize()
func _process(delta: float) -> void:
	spawn()
func spawn():
	if bool_spwan:
		$cooldown.start()
		bool_spwan = false
		var enemi_instance = Enemy_Scene.instantiate()
		enemi_instance.position = Vector2(random.randi_range(30, 1000), random.randi_range(30, 550))
		add_child(enemi_instance)
		
		

func _on_cooldown_timeout() -> void:
	bool_spwan = true
