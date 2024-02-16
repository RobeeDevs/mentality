extends Node2D

@export var enabled: bool = false
@onready var gust_area: Area2D = $gust_area
@onready var lightning_sfx: AudioStreamPlayer2D = $lightning_sfx
@onready var gust_sfx: AudioStreamPlayer2D = $gust_sfx

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.enemy_shocked.connect(Callable(self, "enemy_shocked"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enabled:
		if Input.is_action_just_pressed("player_tactical"):
			gust(200)
			

func fire_primary():
	if enabled:
		pass

func gust(strength: int):
	if enabled:
		gust_sfx.play()
		for body in gust_area.get_overlapping_bodies():
			if "enemy" in body.name:
				body.knockback = Globals.player_position.direction_to(body.global_position) * strength

func enemy_shocked():
	lightning_sfx.play()
