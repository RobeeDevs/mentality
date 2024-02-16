extends Node

const SCREEN_CENTER: Vector2 = Vector2(576, 324)

enum ElementTypes {WATER, FIRE, EARTH, STORM}
enum PlayerClasses {WATER_CLASS, FIRE_CLASS, EARTH_CLASS, STORM_CLASS, NO_CLASS}

var PLAYER_NODE
var BEACON_NODE

var player_node_set: bool = false

var player_score: int = 0

var player_active: bool = true

var player_position = Vector2.ZERO

var player_class: PlayerClasses = PlayerClasses.NO_CLASS

var tactical_ability: String = ""
var tactical_ability_value: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(load("res://img/sprites/player/crosshair.png"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("player_quit"):
		get_tree().quit()
	if not is_instance_valid(PLAYER_NODE):
		PLAYER_NODE = Node2D.new()
