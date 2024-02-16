extends Node2D

var countdown_time: float = 3
var exploded: bool = false
@onready var timer: Timer = $timer
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var time_left_label: Label = $Sprite2D/Label
@onready var area: Area2D = $area
@onready var explosion_sfx: AudioStreamPlayer2D = $explosion_sfx
@onready var countdown_sfx: AudioStreamPlayer2D = $countdown_sfx
@onready var place_bomb_sfx: AudioStreamPlayer2D = $place_bomb_sfx

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = countdown_time
	timer.start()
	countdown_sfx.play()
	place_bomb_sfx.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if exploded:
		time_left_label.text = ""
	else:
#		time_left_label.text = "{t} sec".format({"t": ceil(timer.time_left)})
		time_left_label.text = str(snapped(timer.time_left, 0.01))


func _on_timer_timeout():
	if not exploded:
		particles.emitting = true
		exploded = true
		GlobalSignals.shake_camera.emit()
		$Sprite2D.visible = false
		explosion_sfx.play()
		
		for body in area.get_overlapping_bodies():
			if body.has_method("start_death"):
				body.start_death()

func _on_gpu_particles_2d_finished():
	queue_free()
