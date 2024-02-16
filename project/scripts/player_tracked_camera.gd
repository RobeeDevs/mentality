extends Camera2D

@export var node_to_track: Node2D

@onready var animations: AnimationPlayer = $camera_shake

@export var timer: Timer

var artifacts: Array

enum ZoomLevel {ZOOM_LEVEL_CLOSE, ZOOM_LEVEL_MEDIUM, ZOOM_LEVEL_FAR}
var zoom_level: ZoomLevel = ZoomLevel.ZOOM_LEVEL_MEDIUM

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = node_to_track.global_position

	$tactical_ability_status_label.text = "{n}: {v}".format({
		"n": Globals.tactical_ability, "v": Globals.tactical_ability_value
	})
	
	var fresh_arr = []
	for a in artifacts:
		if is_instance_valid(a):
			fresh_arr.append(a)
	
	if len(fresh_arr) == 0:
		$level_message_label.text = "[center]Return to the beacon to leave[/center]"

	if Globals.PLAYER_NODE:
		$health_label.text = str(Globals.PLAYER_NODE.health)
	set_timer_text(timer)

	if Input.is_action_just_pressed("player_zoom"):
		match zoom_level:
			ZoomLevel.ZOOM_LEVEL_CLOSE:
				zoom_level = ZoomLevel.ZOOM_LEVEL_MEDIUM
				change_label_visibilites(true)
				
				var t: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				t.tween_property(self, "zoom", Vector2(0.5, 0.5), 0.3)
			ZoomLevel.ZOOM_LEVEL_MEDIUM:
				zoom_level = ZoomLevel.ZOOM_LEVEL_FAR
				change_label_visibilites()
				
				var t: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				t.tween_property(self, "zoom", Vector2(0.2, 0.2), 0.3)
			ZoomLevel.ZOOM_LEVEL_FAR:
				zoom_level = ZoomLevel.ZOOM_LEVEL_CLOSE
				change_label_visibilites()
				
				var t: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				t.tween_property(self, "zoom", Vector2(1.0, 1.0), 0.3)

func shake():
	animations.play("camera_shake")
	
func change_label_visibilites(show: bool = false):
	if show:
		$health_label.show()
		$timer_label.show()
		$tactical_ability_status_label.show()
		$artifacts_left_label.show()
		$level_message_label.show()
		for a in artifacts:
			if not is_instance_valid(a):
				artifacts.erase(a)
			else:
				a.sprite.show()
		for c in get_children():
			if c is CanvasItem:
				c.show()
	else:
		$health_label.hide()
		$timer_label.hide()
		$tactical_ability_status_label.hide()
		$artifacts_left_label.hide()
		$level_message_label.hide()
		for a in artifacts:
			if not is_instance_valid(a):
				artifacts.erase(a)
			else:
				a.sprite.hide()
		for c in get_children():
			if c is CanvasItem:
				c.hide()

func set_timer_text(timer):
	var minutes = int(timer.time_left) / 60
	var seconds = int(timer.time_left) % 60

	if seconds < 10:
		seconds = "0{n}".format({'n': seconds})

	$timer_label.text = "{m}: {s}".format({
		'm': minutes,
		's': seconds
	})
