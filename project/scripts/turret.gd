extends Node2D

const BULLET_SCENE = preload("res://scenes/bullet.scn")

var bullet_speed: int = 2000 # 350

var shooting: bool = false

@onready var ray_cast: RayCast2D = $RayCast2D
@onready var shoot_timer: Timer = $shoot_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ray_cast.target_position = to_local(Globals.PLAYER_NODE.global_position)
	if ray_cast.is_colliding():
		if "player" in ray_cast.get_collider().name:
			if not shooting:
				shoot_timer.start()
				shoot_bullet()
				shooting = true
		else:
			shoot_timer.stop()
			shooting = false

func shoot_bullet():
	var nb: RigidBody2D = BULLET_SCENE.instantiate()
	nb.speed = bullet_speed
	nb.lifetime = 0.5
	nb.damage_value = 1.0
	get_tree().root.add_child(nb)
	nb.global_position = global_position
	nb.fire(global_position, Globals.PLAYER_NODE.global_position)
	nb.name = "turret_bullet"
	nb.set_collision_layer_value(2, false)
	nb.set_collision_layer_value(4, true)


func _on_shoot_timer_timeout():
	shoot_bullet()
