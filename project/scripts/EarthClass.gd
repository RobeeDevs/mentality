extends Node2D

@export var enabled: bool = false
@export var wall_model: StaticBody2D

var rock_scene = preload("res://scenes/rock.scn")
var wall_scene = preload("res://scenes/wall.scn")

var walls_left: int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	if not enabled:
		hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enabled:
		if Input.is_action_just_pressed("player_tactical"):
			drop_wall()
		
		if walls_left <= 0:
			wall_model.hide()

func fire_primary():
	if enabled:
		var nb: RigidBody2D = rock_scene.instantiate()
		get_tree().root.add_child(nb)
		nb.global_position = global_position	
		nb.fire(global_position, get_global_mouse_position(), randi_range(-50, 50))
		nb.name = "player_bullet"

func drop_wall():
	if enabled:
		if walls_left > 0:
			if wall_model.can_place:
				var nw: StaticBody2D = wall_scene.instantiate()
				get_tree().root.add_child(nw)
				nw.global_position = wall_model.global_position
				nw.look_at(get_global_mouse_position())
				nw.rotate(deg_to_rad(90))
				nw.scale = Vector2(1.5, 1.5)
				nw.name = "player_wall"

				walls_left -= 1
				Globals.tactical_ability_value = str(walls_left)
