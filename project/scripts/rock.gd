extends RigidBody2D

var speed: int = 500
var damage: int = 20
var collided_bodies = []

func _ready():
	gravity_scale = 0  # Turns off gravity, game automatically makes bodies fall downward.
	max_contacts_reported = 2  # Sets the number of collisions that can be reported at the same time
	angular_velocity = deg_to_rad(randi_range(-2000, 2000))

func _process(delta):
	pass
	
func fire(pos: Vector2, target: Vector2, influence: int = 0):
	apply_impulse(pos.direction_to(target) * (speed + influence))
	look_at(target)
	

func set_color(color: Color):
	$Sprite2D.self_modulate = color # Function to change the color if needed'
	
func destroy():
	damage -= 1  # The ice sickle is piercing, but make it weaken as it hits more enemies
	if damage <= 0:
		queue_free()

func _on_lifetime_timeout():
	queue_free()  # Kills the bullet after the lifetime timer runs out
