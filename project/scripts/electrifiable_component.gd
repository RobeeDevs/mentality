extends Node2D

var damage: int = 4

var shocks_left: int = 3

@export var collision_radius: int = 270 #130

@onready var area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var shock_particles: GPUParticles2D = $ShockParticles
@onready var shock_timer: Timer = $ShockTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_shape.shape.set_radius(collision_radius)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shock_bodies():
	if shocks_left > 0:
		shocks_left -= 1
		if damage > 1:
			for body in area.get_overlapping_bodies():
				if "enemy" in body.name:
					if body != get_parent():
						body.damage(damage - 1)
						body.electrified = true
						body.electrifiable_component.emit_particles()
			get_parent().damage(damage - 1)
			emit_particles()

func emit_particles():
	shock_particles.emitting = true
