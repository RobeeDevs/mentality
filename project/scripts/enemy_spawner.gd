extends Node2D

@export var enemy_scene: PackedScene
@export var player_node: CharacterBody2D
@export var spawn_time: float = 5
@export var spawn_enemies: bool = false
@export var on_screen_to_spawn: bool = true
@export var one_enemy_at_a_time: bool = false
@onready var timer: Timer = $Timer
@onready var vos_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var spawned_enemies: Array[RigidBody2D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if spawn_enemies:
		if one_enemy_at_a_time:
			if vos_notifier.is_on_screen():
				spawn_enemy()
	else:
		timer.wait_time = spawn_time
		timer.start()

func _on_timer_timeout():
	timer.wait_time = spawn_time
	if spawn_enemies:
		if on_screen_to_spawn:
			if vos_notifier.is_on_screen():
				spawn_enemy()
		else:
			spawn_enemy()

func spawn_enemy():
	var ne: CharacterBody2D = enemy_scene.instantiate()
	get_tree().root.add_child(ne)
	ne.name = "enemy"
	ne.global_position = global_position
	ne.PLAYER = player_node

	if one_enemy_at_a_time:
		ne.died.connect(Callable(self, "spawn_enemy"))
	

	return ne

func _on_visible_on_screen_notifier_2d_screen_entered():
	spawn_enemy()
