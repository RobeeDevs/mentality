extends RigidBody2D

@onready var ice_sickle_sfx: AudioStreamPlayer2D = $ice_sickle_sfx

var speed: int = 1000
var damage: int = 5
var collided_bodies = []

func _ready():
	gravity_scale = 0  # Turns off gravity, game automatically makes bodies fall downward.
	max_contacts_reported = 2  # Sets the number of collisions that can be reported at the same time
	ice_sickle_sfx.play()

func _process(delta):
	pass
	
func fire(pos: Vector2, target: Vector2):
	apply_impulse(pos.direction_to(target) * speed)
	look_at(target)
	

func set_color(color: Color):
	$Sprite2D.self_modulate = color # Function to change the color if needed'
	
func destroy():
	queue_free()
	damage -= 1  # The ice sickle is piercing, but make it weaken as it hits more enemies
	if damage <= 0:
		queue_free()

func _on_lifetime_timeout():
	queue_free()  # Kills the bullet after the lifetime timer runs out
