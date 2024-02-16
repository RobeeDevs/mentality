extends RigidBody2D

var speed: int = 600
var offset_init: int = 100
var offset_range: int = randi_range(offset_init - 20, offset_init + 20)
var damage: int = 1
var collided_bodies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = 0
	max_contacts_reported = 2
	$lifetime.wait_time = randf_range(0.2, 1)
	$lifetime.start()
	var scale_rand = randf_range(0.02, 0.04)
	$Sprite2D.scale = Vector2(scale_rand, scale_rand)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func fire(pos: Vector2, target: Vector2):
	var rand = randi_range(-offset_range, offset_range)
	var random_offset = Vector2(rand, rand)
	apply_impulse(pos.direction_to(target + random_offset) * speed)
	look_at(target)
	

func set_color(color: Color):
	$Sprite2D.self_modulate = color # Function to change the color if needed

func destroy():
	queue_free()

func _on_lifetime_timeout():
	queue_free()
