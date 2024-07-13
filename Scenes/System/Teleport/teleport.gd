extends Area2D
# TELEPORT
# a teleport spot that will move the player to a new area by instantiating a fade out
# screen, making the player invisible, and transferring to a new level
@onready var FADEOUT = preload("res://Scenes/UI/FadeOut/fade_out.tscn")
@export var level_to_load : String = ""
@export var play_stairs_sfx : bool = false # if true will play stairs SFX

func _on_body_entered(body):
	if body.is_in_group("PLAYER"):
		Globals.can_play = false
		body.visible = false # hide the player
		var fadeout = FADEOUT.instantiate()
		fadeout.level_to_load = level_to_load # set the load level
		get_parent().add_child(fadeout)
