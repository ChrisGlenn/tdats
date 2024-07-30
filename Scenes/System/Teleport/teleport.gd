extends Area2D
# TELEPORT
# a teleport spot that will move the player to a new area by instantiating a fade out
# screen, making the player invisible, and transferring to a new level
@onready var FADEOUT = preload("res://Scenes/UI/FadeOut/fade_out.tscn")
@onready var STAIR_SFX = $StairsSFX
@export var level_to_load : String = ""
@export var play_stairs_sfx : bool = false # if true will play stairs SFX
@export var play_door_sfx : bool = false # if true will play door SFX
var play_sfx : bool = false
var sfx_timer : int = 36 # timer to play exit sfx


func _process(delta):
	if play_sfx:
		if sfx_timer > 0: sfx_timer -= Globals.timer_ctrl * delta # decrement timer
		else:
			if play_stairs_sfx:
				STAIR_SFX.play()
				play_sfx = false # reset the play_sfx check to avoid multiple play starts
			elif play_door_sfx: pass


func _on_body_entered(body):
	if body.is_in_group("PLAYER"):
		Globals.can_play = false # stops further movement
		body.scene_change = true # changes variable on player
		var fadeout = FADEOUT.instantiate()
		fadeout.countdown = true # set the countdown to true
		fadeout.level_to_load = level_to_load # set the load level
		get_parent().add_child(fadeout)
		if play_stairs_sfx or play_door_sfx: play_sfx = true # will play a SFX
