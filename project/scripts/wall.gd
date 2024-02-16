extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@export var is_model: bool = false
var can_place: bool = false

var health: int = 10
var radius = 50
var dist

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_model:
		set_collision_layer_value(1, false)
		set_collision_layer_value(2, false)
		set_collision_layer_value(3, false)
		set_collision_layer_value(4, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_model:
		dist = get_parent().global_position.distance_to(get_global_mouse_position())
		if dist > 185:
			var mouse_dir = (get_local_mouse_position() - Vector2.ZERO).normalized()

			transform.origin = Vector2.ZERO + (mouse_dir * radius)
			sprite.look_at(get_global_mouse_position())
			sprite.rotate(deg_to_rad(270))
			sprite.modulate = Color8(255, 255, 255)
			$CollisionShape2D.look_at(get_global_mouse_position())
			$CollisionShape2D.rotate(deg_to_rad(270))
			can_place = true
		else:
			sprite.modulate = Color8(255, 255, 255, 120)
			can_place = false
