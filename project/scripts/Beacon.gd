extends Node2D

var player_is_present: bool = false

func _ready():
	pass

func _process(delta):
	player_is_present = false
	for b in $beacon_area.get_overlapping_bodies():
		if "player" in b.name:
			player_is_present = true
