extends Node2D

@export var enabled: bool = true
@onready var fire_blast_particles: GPUParticles2D = $fire_blast_particles
@onready var fire_blast_area: Area2D = $fire_blast_area
@onready var flamethrower_sfx: AudioStreamPlayer2D = $flamethrower_sfx

var ember_scene = preload("res://scenes/ember.scn")
var bomb_scene = preload("res://scenes/bomb.scn")

var flamethrower_active: bool = false

var bombs_left: int = 3

var fire_blasted_bodies: Array[CharacterBody2D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enabled:
		if flamethrower_active:
			var nb: RigidBody2D = ember_scene.instantiate()
			get_tree().root.add_child(nb)
			nb.global_position = global_position
			nb.fire(global_position, get_global_mouse_position())
			nb.name = "player_bullet"

			if Input.is_action_just_released("player_shoot"):
				flamethrower_active = false
		else:
			flamethrower_sfx.volume_db = lerp(flamethrower_sfx.volume_db, -50.0, 0.1)


		if Input.is_action_just_pressed("player_tactical"):
			drop_bomb()
			

func fire_primary():
	if enabled:
		flamethrower_sfx.volume_db = 0
		flamethrower_sfx.play()
		flamethrower_active = true

func fire_blast():
	if enabled:
		fire_blast_particles.emitting = true
		
		for prev_body in fire_blasted_bodies:
			if not is_instance_valid(prev_body):
				fire_blasted_bodies.erase(prev_body)
			else:
				prev_body.damage(2)

		for body in fire_blast_area.get_overlapping_bodies():
			if "enemy" in body.name:
				body.damage(5)
				if not fire_blasted_bodies.has(body):
					fire_blasted_bodies.append(body)
				


func drop_bomb():
	if enabled:
		if bombs_left >= 1:
			bombs_left -= 1
			Globals.tactical_ability_value = str(bombs_left)
			var nbomb: Node2D = bomb_scene.instantiate()
			get_tree().root.add_child(nbomb)
			nbomb.global_position = global_position
			nbomb.name = "player_bomb"


func _on_fire_blast_timer_timeout():
	fire_blast()
