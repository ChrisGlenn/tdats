extends Node2D
# CUTSCENE SYSTEM
# reads the cutscene data from a JSON file and then the actors move accordingly
@export var story_beat : int = -4 # set the corresponding story 'beat'
var cutscene_characters : Array = [] # set the current actors for the cutscene
var cutscene_data : Dictionary = {} # dictionary to hold parsed JSON cutscene data
var cutscene_step : int = 0 # iterates through the cutscene JSON data
var cutscene_finished : bool = false # true if cutscene is completed
var cutscene_timer : int = 0 # timer for the cutscene
var cutscene_paused : bool = false # if true then the cutscene will pause


func _ready():
	# get the cutscene data
	if story_beat != -4 and story_beat == Globals.game_stage:
		Globals.in_cutscene = true # the gmae in 'in cutscene'
		Globals.can_play = false # stop player movement
		cutscene_data = Cutscenes.set_cutscene(story_beat)
		get_parent().clear_characters() # run the function to clear all the actors

func _process(delta):
	cutscene(delta) # cutscene function


func cutscene(clock):
	if cutscene_step < cutscene_data.size() and !cutscene_paused:
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
			actor.cutscene_mode = true # enable cutscene mode
			actor.face_dir = cutscene_data.values()[cutscene_step]["face_dir"] # face direction
			actor.cutscene_parent = self # set cutscene parent as self
			get_parent().add_child(actor)
			cutscene_characters.append(actor) # add actor to the local characters array
			cutscene_step += 1 # advance to the next step
		"npc":
			# move the NPC
			cutscene_characters[cutscene_data.values()[cutscene_step]["actor"]].face_dir = cutscene_data.values()[cutscene_step]["face_dir"]
			cutscene_characters[cutscene_data.values()[cutscene_step]["actor"]].move_to = cutscene_data.values()[cutscene_step]["move_to"]
			cutscene_characters[cutscene_data.values()[cutscene_step]["actor"]].is_moving = true # set the NPC to move
			cutscene_step += 1 # advance to the next step
			cutscene_paused = true # pause the cutscene to allow character to move
		"dialogue":
			# play the set dialogue
			cutscene_step += 1 # advance to the next step

