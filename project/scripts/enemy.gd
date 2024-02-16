extends CharacterBody2D

const LEFT_SPRITE = preload("res://img/sprites/enemy/orange_enemy_left.png")
const RIGHT_SPRITE = preload("res://img/sprites/enemy/orange_enemy_right.png")

const BULLET_SCENE = preload("res://scenes/bullet.scn")

const GRAVITY = 1000
const JUMP_SPEED = -(GRAVITY * 0.8)

const LINE_OFFSET = Vector2(515, 275)

const DAMAGED_COLOR = Color8(255, 0, 0)
const FROZEN_COLOR = Color(0, 7, 100)
const ELECTRIFIED_COLOR = Color8(25500, 25500, 255, 255)

signal died

var Y_VELOCITY = 100
var VELOCITY_CLAMP = 200
var MAX_VELOCITY_CLAMP = 600

var health = 20
var speed = 1

var bullet_speed: int = 1000 # 350

var shoot_time: float = 2

var active: bool = true

var knockback: Vector2 = Vector2.ZERO

var clamp_velocity: bool = true

var frozen: bool = false

var dying: bool = false

var vortexed: bool = false
var vortex_pos = Vector2.ZERO

var electrified: bool = false

var beacon_closer: bool = false

var distance_to_player = 0

var sp
@export var PLAYER: CharacterBody2D

@onready var electrifiable_component = $ElectrifiableComponent
@onready var sprite: Sprite2D = $Sprite

func _ready():
	PLAYER = Globals.PLAYER_NODE

func movement(delta):
	if active:
		var direction_to_player = $Sprite.global_position.direction_to(Globals.PLAYER_NODE.global_position)
		$ray_to_player.global_position = $Sprite.global_position
		$ray_to_player.target_position = direction_to_player * 1000

		if $ray_to_player.is_colliding():
			var col_name = $ray_to_player.get_collider().to_string().split(':')[0]
			if "player" in col_name:
				distance_to_player = $Sprite.global_position.distance_to(PLAYER.global_position)
				
		var x_distance_to_player = Globals.PLAYER_NODE.global_position.x - global_position.x
		velocity.x += x_distance_to_player / 20
		if clamp_velocity:
			velocity.x = clamp(velocity.x, -VELOCITY_CLAMP, VELOCITY_CLAMP)
		else:
			velocity.x = clamp(velocity.x, -MAX_VELOCITY_CLAMP, MAX_VELOCITY_CLAMP)
		
		var y_distance_to_player = PLAYER.global_position.y - global_position.y
		velocity.y += y_distance_to_player / 20
		
		if clamp_velocity:
			velocity.y = clamp(velocity.y, -VELOCITY_CLAMP, VELOCITY_CLAMP)
		else:
			velocity.y = clamp(velocity.y, -MAX_VELOCITY_CLAMP, MAX_VELOCITY_CLAMP)
		
		knockback = knockback.move_toward(Vector2.ZERO, 5)
		velocity += knockback

		if x_distance_to_player < 0:
			sprite.flip_h = false
		elif x_distance_to_player > 0:
			sprite.flip_h = true
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.06)

func vortex_movement():
	var dir = vortex_pos - global_position
	velocity += dir / 20
	velocity = clamp(velocity, Vector2(-VELOCITY_CLAMP, -VELOCITY_CLAMP), Vector2(VELOCITY_CLAMP, VELOCITY_CLAMP))

func _physics_process(delta):
	if vortexed:
		vortex_movement()
	else:
		movement(delta)

	$Sprite/health_label.text = str(health)
		
	var col = move_and_collide(velocity * delta)
	
	if not col == null:
		if "player_bullet" in col.get_collider().to_string().split(':')[0]:
			if self not in col.get_collider().collided_bodies:
				damage(col.get_collider().damage)
				col.get_collider().collided_bodies.append(self)
				col.get_collider().destroy()

func damage(amount: int):
	if (health - amount) <= 0:
		start_death()
	else:
		health -= amount
	
	var final_color = Color8(255, 255, 255)
	
	if electrified:
		final_color = ELECTRIFIED_COLOR
	if frozen:
		final_color = FROZEN_COLOR

	var damaged_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	$Sprite.modulate = DAMAGED_COLOR
	damaged_tween.tween_property($Sprite, "modulate", final_color, 1.0)

func start_death():
	health = 0
	Globals.player_score += 1
	Globals.PLAYER_NODE.add_energy(100)
	active = false
	velocity = Vector2.ZERO
	var tw = get_tree().create_tween()
	# Quickly shrink enemy before dying
	tw.tween_property($Sprite, "scale", Vector2(0, 0), 0.5).set_trans(Tween.TRANS_ELASTIC)
	$CollisionShape2D.set_deferred("disabled", true)
	#$death_particles.emitting = true
	$death_countdown.start()

func _on_death_countdown_timeout():
	died.emit()
	queue_free()


func _on_shoot_timer_timeout():
	if active:
		shoot_bullet()
	
func shoot_bullet():
	var nb: RigidBody2D = BULLET_SCENE.instantiate()
	get_tree().root.add_child(nb)
	nb.global_position = global_position
	nb.speed = bullet_speed
	nb.fire(global_position, Globals.BEACON_NODE.cus_global_pos if beacon_closer else PLAYER.global_position)
	nb.name = "enemy_bullet"
	nb.set_color(Color8(100, 100, 255))
	nb.set_collision_layer_value(2, false)
	nb.set_collision_layer_value(4, true)

func freeze():
	frozen = true
	active = false
	$Sprite.modulate = FROZEN_COLOR

func enter_vortex(pos: Vector2):
	if not vortexed and not frozen:
		vortexed = true
		velocity = Vector2(200, 200)
		vortex_pos = pos

func exit_vortex():
	vortexed = false
	velocity = Vector2.ZERO
	vortex_pos = Vector2.ZERO
	
func set_electrified(damage_amnt: int):
	electrified = true
	if (health - damage_amnt < 1) and not dying:
		start_death()
	else:
		damage(damage_amnt)
	electrifiable_component.damage = damage_amnt
	electrifiable_component.shock_bodies()
	$Sprite.self_modulate = ELECTRIFIED_COLOR

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			if Globals.PLAYER_NODE.class_enum == Globals.PlayerClasses.STORM_CLASS:
				if global_position.distance_to(Globals.player_position) <= 275:
					GlobalSignals.enemy_shocked.emit()
					set_electrified(4)
