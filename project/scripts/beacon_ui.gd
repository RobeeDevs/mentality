extends Control

var level_of_selection: int = 0  # Keeps track of which options to show and which ones to not.
var wait: bool = false  # Makes it so that you only do one input per frame, prevents 2 levels of
						# selection from passing within one frame.

func _ready():
	pass

func _process(delta):
	wait = false  # Resets the wait variable each frame
#	if level_of_selection == 0 and not wait:
#		if Input.is_action_just_pressed("player_select_option1"):
#			$strengthen_heal_box.visible = false
#			$strengthen__box.visible = true
#			level_of_selection = 1
#			wait = true
#		elif Input.is_action_just_pressed("player_select_option2"):
#			$strengthen_heal_box.visible = false
#			wait = true
#
#	if level_of_selection == 1 and not wait:
#		if Input.is_action_just_pressed("player_select_option1"):
#			$strengthen__box.visible = false
#			level_of_selection = 2
#			wait = true
#		elif Input.is_action_just_pressed("player_select_option2"):
#			$strengthen__box.visible = false
#			level_of_selection = 2
#			wait = true
