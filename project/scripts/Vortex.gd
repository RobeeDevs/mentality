extends Node2D

@onready var area = $Area2D
@onready var animations = $animations
@onready var vortex_sfx: AudioStreamPlayer2D = $vortex_sfx
var enemies_vortexed = []

var vortex_damage = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	animations.play("rotate")
	vortex_sfx.play()
	$Sprite2D.scale = Vector2.ZERO
	var spawn_tween = create_tween().tween_property($Sprite2D, "scale", Vector2(1, 1), 2.0).set_trans(Tween.TRANS_BOUNCE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in area.get_overlapping_bodies():
		if "enemy" in body.name:
			body.enter_vortex(global_position)


func _on_lifetime_timeout():
	var exit_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	exit_tween.tween_property($Sprite2D, "scale", Vector2(0, 0), 2.0)
	exit_tween.tween_callback(Callable(self, "tween_finished"))

func tween_finished():
	for body in area.get_overlapping_bodies():
		if "enemy" in body.name:
			body.exit_vortex()
	queue_free()


func _on_area_2d_body_entered(body):
	if "enemy" in body.name:
		if body not in enemies_vortexed:
			enemies_vortexed.append(body)


func _on_damage_tick_timeout():
	for enemy in enemies_vortexed:
		if is_instance_valid(enemy):
			enemy.damage(vortex_damage)
