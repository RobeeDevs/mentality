extends CharacterBody2D

signal injured

@export var class_node: Node2D
var class_enum

var BULLET_SCENE: PackedScene = preload("res://scenes/bullet.scn")

var water_player_texture: CompressedTexture2D = preload("res://img/sprites/player/water/White_Boy_Character_Water.png")
var fire_player_texture: CompressedTexture2D = preload("res://img/sprites/player/fire/White_Boy_Character_Fire.png")
var earth_player_texture: CompressedTexture2D = preload("res://img/sprites/player/earth/White_Boy_Character_Earth.png")
var storm_player_texture: CompressedTexture2D = preload("res://img/sprites/player/storm/White_Boy_Character_Storm.png")

var SPEED: float = 480.0
const VERTICAL_VELOCITY: float = -200.0
var speed_lerp_weight: float = 0.06

var bullet_speed: int = 1000

var health: int = 20

var ability_energy: int = 0
var max_ability_energy: int = 1000

var radial_shot_direcs = [
	Vector2(-10, 0),
	Vector2(-7.5, -2.5),
	Vector2(-5, -5),
	Vector2(-2.5, -7.5),
	Vector2(0, -10),
	Vector2(2.5, -7.5),
	Vector2(5, -5),
	Vector2(7.5, -2.5),
	Vector2(10, 0),
	Vector2(7.5, 2.5),
	Vector2(5, 5),
	Vector2(2.5, 7.5),
	Vector2(0, 10),
	Vector2(-2.5, 7.5),
	Vector2(-5, 5),
	Vector2(-7.5, 2.5)
]

@onready var WaterClassNode = $WaterClass
@onready var FireClassNode = $FireClass
@onready var EarthClassNode = $EarthClass
@onready var StormClassNode = $StormClass

@onready var sprite: Sprite2D = $sprite
@onready var burn_timer: Timer = $burn_timer

func _ready():
	match class_node:
		WaterClassNode:
			class_enum = Globals.PlayerClasses.WATER_CLASS
			Globals.player_class = class_enum
			Globals.tactical_ability = "Vortex"
			Globals.tactical_ability_value = "3"
			sprite.texture = water_player_texture
		FireClassNode:
			class_enum = Globals.PlayerClasses.FIRE_CLASS
			Globals.player_class = class_enum
			Globals.tactical_ability = "Bombs"
			Globals.tactical_ability_value = "3"
			sprite.texture = fire_player_texture
		EarthClassNode:
			class_enum = Globals.PlayerClasses.EARTH_CLASS
			Globals.player_class = class_enum
			Globals.tactical_ability = "Walls"
			Globals.tactical_ability_value = "3"
			sprite.texture = earth_player_texture
			SPEED = 190.0
		StormClassNode:
			class_enum = Globals.PlayerClasses.STORM_CLASS
			Globals.player_class = class_enum
			Globals.tactical_ability = "STORM_TACTICAL"
			Globals.tactical_ability_value = "3"
			sprite.texture = storm_player_texture
			speed_lerp_weight = 0.04
			SPEED = 350

func _physics_process(delta):
	if Globals.player_active:
		movement()
		Globals.player_position = global_position
	else:
		velocity.y = lerp(velocity.y, 0.0, 0.1)
		velocity.x = lerp(velocity.x, 0.0, 0.1)

	#var col = move_and_collide(velocity * delta)

	move_and_slide()
	for col_i in get_slide_collision_count():
		var col = get_slide_collision(col_i)
		if not col == null:
			if "enemy_bullet" in col.get_collider().to_string().split(':')[0]:
				damage(col.get_collider().damage_value, col.get_collider())
			elif "turret_bullet" in col.get_collider().to_string().split(':')[0]:
				if not col.get_collider().dead:
					damage(col.get_collider().damage_value, col.get_collider())
					col.get_collider().dead = true

	if not $area.get_overlapping_bodies():
		burn_timer.stop()
		SPEED = 480.0
	for body in $area.get_overlapping_bodies():
		if "tilemap" in body.name:
			if burn_timer.is_stopped():
				SPEED /= 2.5
				damage(1)
				burn_timer.start()

	ability_energy = clamp(ability_energy, 0, max_ability_energy)

	if Input.is_action_just_pressed("player_shoot"):
		if Globals.player_active:
			#shoot_bullet()
			class_node.fire_primary()

func movement():
	# Handle Jump.
#	if Input.get_action_raw_strength("player_up"):
#		velocity.y = -SPEED
#	elif Input.get_action_raw_strength("player_down"):
#		velocity.y = SPEED
#	else:
#		velocity.y = lerp(velocity.y, 0.0, 0.1)
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("player_left", "player_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = lerp(velocity.x, 0.0, 0.1)
	var direc = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	if direc:
		velocity = direc * SPEED
		velocity = lerp(velocity, direc * SPEED, speed_lerp_weight)
	else:
		velocity = lerp(velocity, Vector2.ZERO, speed_lerp_weight)

	if velocity.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func damage(amnt, col=null):
	if health - amnt <= 0:
		died()
	else:
		health -= amnt
		emit_signal("injured", health)
	if col:
		col.queue_free()

func shoot_radial_shot(energy_cost: int):
	ability_energy -= energy_cost
	var rbullets = []
	for i in radial_shot_direcs:
		var nrb = BULLET_SCENE.instantiate()
		get_tree().root.add_child(nrb)
		nrb.global_position = global_position + (i * 4)
		nrb.name = "player_bullet"
		nrb.fire(global_position, global_position + (i * 100))
		rbullets.append(nrb)

func add_energy(amount):
	if ability_energy + amount > max_ability_energy:
		ability_energy = max_ability_energy
	else:
		ability_energy += amount
		
func consume_energy(amount: int):
	if ability_energy - amount < 0:
		ability_energy = 0
	else:
		ability_energy -= amount
		
func died():
	if get_tree():
		for n in get_tree().root.get_children():
			if "enemy" in n.name:
				if "bullet" in n.name:
					n.queue_free()
				else:
					n.active = false
					n.queue_free()
		get_tree().change_scene_to_file("res://scenes/home_screen.scn")


func beacon_area_entered():
	#$sprite.modulate = Color8(0, 0, 255, 255)
	pass
	
func beacon_area_exited():
	#$sprite.modulate = Color8(255, 255, 255, 255)
	pass


func _on_burn_timer_timeout():
	damage(1)
