extends CanvasLayer
# FADE OUT
# plays the fade out animation then loads the next level to display
var level_to_load : String = ""
var countdown : bool = false # checks if there will be a countdown before playing the animation
var timer_amnt : int = 100 # amount to countdown if timer is set


func _ready():
	if !countdown:
		$AnimationPlayer.play("fade_out") # start the animation
	else:
		visible = false # hide the fade out until timer is done

func _process(delta):
	if countdown:
		if timer_amnt > 0:
			timer_amnt -= Globals.timer_ctrl * delta # decrement timer
		else:
			visible = true # show the fade out
			$AnimationPlayer.play("fade_out") # play the animation
			countdown = false # set back to false to stop timer from continuously playing


func _on_animation_player_animation_finished(_anim_name):
	if level_to_load.length() > 0:
		var _next_level = get_tree().change_scene_to_file(level_to_load) # change the scene
	else:
		print("ERROR: LEVEL NOT SET") # let myself know I messed up
		get_tree().quit() # quit to really drive the mistake home!
