extends CanvasLayer
# FADE OUT
# plays the fade out animation then loads the next level to display
var level_to_load : String = ""

func _ready():
	$AnimationPlayer.play("fade_out") # start the animation

func _on_animation_player_animation_finished(_anim_name):
	if level_to_load.length() > 0:
		var _next_level = get_tree().change_scene_to_file(level_to_load) # change the scene
	else:
		print("ERROR: LEVEL NOT SET")
		get_tree().quit()
