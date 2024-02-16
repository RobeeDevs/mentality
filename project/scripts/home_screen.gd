extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_earth_button_button_up():
	get_tree().change_scene_to_file("res://scenes/earth_world.scn")


func _on_water_button_button_up():
	pass # Replace with function body.


func _on_fire_button_button_up():
	get_tree().change_scene_to_file("res://scenes/fire_world.scn")


func _on_storm_button_button_up():
	pass # Replace with function body.
