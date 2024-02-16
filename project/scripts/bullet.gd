extends RigidBody2D

var speed: int = 1000
var damage_value: float = 0.1
var lifetime: float = 10.0
var dead: bool = false

func _ready():
	gravity_scale = 0  # Turns off gravity, game automatically makes bodies fall downward.
	max_contacts_reported = 2  # Sets the number of collisions that can be reported at the same time

func _process(delta):
	pass
	
func fire(pos: Vector2, target: Vector2):
	apply_impulse(pos.direction_to(target) * speed)
	look_at(target)
	$lifetime.start(lifetime)

func set_color(color: Color):
	$Sprite2D.self_modulate = color # Function to change the color if needed

func _on_lifetime_timeout():
	queue_free()  # Kills the bullet after the lifetime timer runs out
