# If you want to make a sliding effect after freezing the ground, set don't set the velocity
# to zero in the freeze() function in the enemy script

extends Node2D
class_name WaterClass

var ice_scikle_scene = preload("res://scenes/ice_sickle.scn")

@export var enabled: bool = false
@onready var freeze_area = $freeze_area

var vortex = preload("res://scenes/vortex.scn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enabled:
		if Input.is_action_just_pressed("player_tactical"):
			create_vortex()
		flash_freeze()
	
func fire_primary():
	if enabled:
		var nb: RigidBody2D = ice_scikle_scene.instantiate()
		get_tree().root.add_child(nb)
		nb.global_position = global_position
		nb.fire(global_position, get_global_mouse_position())
		nb.name = "player_bullet"

func flash_freeze():
	if enabled:
		for body in freeze_area.get_overlapping_bodies():
			if "enemy" in body.name:
				body.freeze()

func create_vortex():
	if enabled:
		var nv = vortex.instantiate()
		nv.global_position = global_position
		get_tree().root.add_child(nv)
