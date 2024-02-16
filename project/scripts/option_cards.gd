extends Node2D
#
#@export var player_node: CharacterBody2D
#
#var card1_active = false
#var card2_active = false
#var card3_active = false
#
## Animation player nodes
#@onready var card1_anim = $card1/card1_animation
#@onready var card2_anim = $card2/card2_animation
#@onready var card3_anim = $card3/card3_animation
#
#@onready var enter_label = $enter_label
#var enter_label_pos1 = Vector2(191, 423)
#var enter_label_pos2 = Vector2(353, 423)
#var enter_label_pos3 = Vector2(509, 423)
#
## Tween type and time for moving the enter label
#var tween_type = Tween.TRANS_CUBIC
#var tween_time = 0.1
#
## Sets the enter label above which ever card is first pickde after all of them have been deactivated
#var enter_label_reset: bool = false
#
#var time_slowed: bool = false
#
#func _ready():
	#Globals.PLAYER_NODE = player_node
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if Input.is_action_just_pressed("player_select_option1"):
		#if card1_active:
			#card1_anim.play("card1_deactivate")
			#card1_active = false
		#else:
			#card1_activate()
	#
	#elif Input.is_action_just_pressed("player_select_option2"):
		#if card2_active:
			#card2_anim.play("card2_deactivate")
			#card2_active = false
		#else:
			#card2_activate()
			#
	#elif Input.is_action_just_pressed("player_select_option3"):
		#if card3_active:
			#card3_anim.play("card3_deactivate")
			#card3_active = false
		#else:
			#card3_activate()
			#
	#if card1_active or card2_active or card3_active:
		#enter_label.visible = true
		#Globals.player_active = false
		#if not time_slowed:
			#get_tree().create_tween().tween_property(Engine, "time_scale", 0.2, 0.2).set_trans(Tween.TRANS_CUBIC)
			#time_slowed = true
	#else:
		#enter_label.visible = false
		#enter_label_reset = true
		#Engine.time_scale = 1.0
		#Globals.player_active = true
		#time_slowed = false
		#
	#if Input.is_action_just_pressed("player_enter"):
		#if Globals.PLAYER_NODE.ability_energy >= 100:
			#if card2_active:
				#Globals.BEACON_NODE.shoot_radial_shot(100)
				#card2_anim.play("card2_deactivate")
				#card2_active = false
			#if card3_active:
				#Globals.BEACON_NODE.heal(20, 100)
				#card3_anim.play("card3_deactivate")
				#card3_active = false
		#else:
			#card1_anim.play("no_energy")
			#card2_anim.play("no_energy")
			#card3_anim.play("no_energy")
		#if Globals.PLAYER_NODE.ability_energy >= 300:
			#if card1_active:
				#Globals.PLAYER_NODE.shoot_radial_shot(300)
				#card1_anim.play("card1_deactivate")
				#card1_active = false
		#else:
			#card1_anim.play("no_energy")
			#card2_anim.play("no_energy")
			#card3_anim.play("no_energy")
#
#func card1_activate():
	#card1_anim.play("card1_activate")
	#card1_active = true
	#if enter_label_reset:
		#enter_label.position = enter_label_pos1
		#enter_label_reset = false
	#get_tree().create_tween().tween_property(enter_label, "position", enter_label_pos1, tween_time).set_trans(tween_type)
	#if card2_active:
		#card2_anim.play("card2_deactivate")
		#card2_active = false
	#if card3_active:
		#card3_anim.play("card3_deactivate")
		#card3_active = false
#
#func card2_activate():
	#card2_anim.play("card2_activate")
	#card2_active = true
	#if enter_label_reset:
		#enter_label.position = enter_label_pos2
		#enter_label_reset = false
	#get_tree().create_tween().tween_property(enter_label, "position", enter_label_pos2, tween_time).set_trans(tween_type)
	#if card1_active:
		#card1_anim.play("card1_deactivate")
		#card1_active = false
	#if card3_active:
		#card3_anim.play("card3_deactivate")
		#card3_active = false
#
#func card3_activate():
	#card3_anim.play("card3_activate")
	#card3_active = true
	#if enter_label_reset:
		#enter_label.position = enter_label_pos3
		#enter_label_reset = false
	#get_tree().create_tween().tween_property(enter_label, "position", enter_label_pos3, tween_time).set_trans(tween_type)
	#if card1_active:
		#card1_anim.play("card1_deactivate")
		#card1_active = false
	#if card2_active:
		#card2_anim.play("card2_deactivate")
		#card2_active = false
