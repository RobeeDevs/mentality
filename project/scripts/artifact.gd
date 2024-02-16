extends Node2D

signal collected_signal

const WATER_ARTIFACT = preload("res://img/sprites/water_textures/water_artifact.png")
const FIRE_ARTIFACT = preload("res://img/sprites/fire_textures/fire_artifact.png")
const EARTH_ARTIFACT = preload("res://img/sprites/earth_textures/earth_artifact.png")
const STORM_ARTIFACT = preload("res://img/sprites/storm_textures/storm_artifact.png")

@export var element: Globals.ElementTypes
@onready var sprite: Sprite2D = $sprite
@onready var area: Area2D = $Area2D
@onready var collected_particles: GPUParticles2D = $collected_particles

var collected: bool = false
var start_end_animations: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	match element:
		Globals.ElementTypes.WATER:
			sprite.texture = WATER_ARTIFACT
		Globals.ElementTypes.FIRE:
			sprite.texture = FIRE_ARTIFACT
		Globals.ElementTypes.EARTH:
			sprite.texture = EARTH_ARTIFACT
		Globals.ElementTypes.STORM:
			sprite.texture = STORM_ARTIFACT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in area.get_overlapping_bodies():
		if "player" in body.name:
			collected = true

	if collected and not start_end_animations:
		collected_signal.emit()
		
		var t = create_tween()
		t.set_trans(Tween.TRANS_CUBIC)
		t.tween_property(sprite, "scale", Vector2(0, 0), 1.0)
		collected_particles.finished.connect(func(): queue_free())
		collected_particles.emitting = true

		start_end_animations = true
