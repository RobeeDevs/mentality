extends Node2D

@onready var level_timer: Timer = $level_timer
@onready var artifacts_left_label: RichTextLabel = $player_tracked_camera/artifacts_left_label

var num_artifacts_left: int
var all_artifacts_collected: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.PLAYER_NODE = $player
	$player.injured.connect(Callable(self, "player_injured"))
	GlobalSignals.shake_camera.connect(Callable(self, "shake_camera"))
	$music.play()
	num_artifacts_left = len(get_tree().get_nodes_in_group("artifacts"))
	artifacts_left_label.text = "Artifacts left: {n}".format({'n': num_artifacts_left})
	for artifact in get_tree().get_nodes_in_group("artifacts"):
		artifact.collected_signal.connect(Callable(self, "artifact_collected"))

	$player_tracked_camera.artifacts = get_tree().get_nodes_in_group("artifacts")

	level_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if all_artifacts_collected:
		if $Beacon.player_is_present:
			clean_tree_and_switch()

func artifact_collected():
	num_artifacts_left -= 1
	if num_artifacts_left > 0:
		level_timer.start(level_timer.time_left + 20)
	else:
		all_artifacts_collected = true

	artifacts_left_label.text = "Artifacts left: {n}".format({'n': num_artifacts_left})
	$player.health += 4

func player_injured(health):
	$player_tracked_camera.shake()


func _on_level_timer_timeout():
	clean_tree_and_switch()

func clean_tree_and_switch():
	for n in get_tree().root.get_children():
		if "enemy" in n.name:
			if "bullet" in n.name:
				n.queue_free()
			else:
				n.active = false
				n.queue_free()
	get_tree().change_scene_to_file("res://scenes/home_screen.scn")
