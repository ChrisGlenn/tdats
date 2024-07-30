extends CanvasLayer
# FADE IN
# fades in and relinquishes control back to the player
# can set a timer to start the fade in if needed
@export var fade_in_beats : Array = [] # if the fade in timer cooresponds with a story beat
@export var fade_in_timer : bool = false # if the fade in timer is activated
@export var fade_timer_amount : int = 80 # amount of the fade in timer
@export var give_control : bool = true # will give player control if set


func _ready():
	Globals.can_play = false # stop player from moving
	if !fade_in_timer: 
		if fade_in_beats.size() > 0:
			for n in fade_in_beats.size():
				if fade_in_beats[n] == Globals.game_stage:
					fade_in_timer = true # turn on the timer if the current beat corresponds with set beats
					break; # break out of the loop
				elif fade_in_beats[n] != Globals.game_stage and n == fade_in_beats.size()-1:
					$AnimationPlayer.play("fade_in") # else play the animation
		else: 
			$AnimationPlayer.play("fade_in") # start the animation

func _process(delta):
	if fade_in_timer:
		# count down the timer
		if fade_timer_amount > 0:
			fade_timer_amount -= Globals.timer_ctrl * delta # decrement timer
		else:
			$AnimationPlayer.play("fade_in") # start the animation


func _on_animation_player_animation_finished(_anim_name):
	if give_control and !Globals.in_cutscene: Globals.can_play = true # let the player resume playing
	queue_free() # delete self once animation is over