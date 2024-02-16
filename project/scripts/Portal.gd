extends Node2D

const WATER_PORTAL = preload("res://img/sprites/water_textures/water_portal.png")
const FIRE_PORTAL = preload("res://img/sprites/fire_textures/fire_portal.png")
const EARTH_PORTAL = preload("res://img/sprites/earth_textures/earth_portal.png")
const STORM_PORTAL = preload("res://img/sprites/storm_textures/storm_portal.png")

@export var id: int
@export var linked_portal: Node2D
@export var element: Globals.ElementTypes

@onready var cooldown_timer: Timer = $cooldown
@onready var sprite: Sprite2D = $sprite

var on_cooldown: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	match element:
		Globals.ElementTypes.WATER:
			sprite.texture = WATER_PORTAL
		Globals.ElementTypes.FIRE:
			sprite.texture = FIRE_PORTAL
		Globals.ElementTypes.EARTH:
			sprite.texture = EARTH_PORTAL
		Globals.ElementTypes.STORM:
			sprite.texture = STORM_PORTAL


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if not linked_portal == null:
		if not on_cooldown:
			linked_portal.set_on_cooldown()
			if body is RigidBody2D:
				PhysicsServer2D.body_set_state(
					body.get_rid(),
					PhysicsServer2D.BODY_STATE_TRANSFORM,
					Transform2D.IDENTITY.translated(linked_portal.global_position)
				)
			else:
				if "player" in body.name:
					body.global_position = linked_portal.global_position
			cooldown_timer.start()
			on_cooldown = true

func set_on_cooldown():
	on_cooldown = true
	cooldown_timer.start()

func _on_cooldown_timeout():
	on_cooldown = false
