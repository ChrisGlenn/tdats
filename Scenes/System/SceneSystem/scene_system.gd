extends Node2D
# CUTSCENE SYSTEM
# reads the cutscene data from a JSON file and then the actors move accordingly
@export var story_beat : int = -4 # set the corresponding story 'beat'
var cutscene_characters : Array = [] # set the current actors for the cutscene
var cutscene_data : Dictionary = {} # dictionary to hold parsed JSON cutscene data
var cutscene_step : int = 0 # iterates through the cutscene JSON data
var cutscene_finished : bool = false # true if cutscene is completed
var cutscene_timer : int = 0 # timer for the cutscene


func _ready():
	# get the cutscene data
	if story_beat != -4 and story_beat == Globals.game_stage:
		cutscene_data = Cutscenes.set_cutscene(story_beat)

func _process(delta):
	cutscene(delta) # cutscene function

func cutscene(clock):
	if cutscene_step < cutscene_data.size():
		if cutscene_timer > 0:
			# decrement the timer and then move on
			cutscene_timer -= clock * Globals.timer_ctrl
		else:
			cutscene_timer = 0 # stop it at zero
			var cutscene_mode = cutscene_data.values()[cutscene_step]["mode"]
			cutscene_modes(cutscene_mode)

func cutscene_modes(mode):
	match mode:
		"timer":
			cutscene_timer = cutscene_data.values()[cutscene_step]["amount"] # set the timer
			print("TIMER") # DEBUG
			cutscene_step += 1 # advance to the next step
		"spawn":
			# set the position of the actor
			var actor_load = load(cutscene_data.values()[cutscene_step]["path"])
			var actor = actor_load.instantiate()
			actor.global_position = Vector2(cutscene_data.values()[cutscene_step]["start_x"], cutscene_data.values()[cutscene_step]["start_y"])
			get_parent().add_child(actor)
			cutscene_step += 1 # advance to the next step

