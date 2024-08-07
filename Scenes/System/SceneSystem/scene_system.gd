extends Node2D
# CUTSCENE SYSTEM
# reads the cutscene data from a JSON file and then the actors move accordingly
@export var story_beat : int = -4 # set the corresponding story 'beat'
@export var cutscene_path : String = "" # path to the JSON file that holds the cutscenes
var cutscene_characters : Array = [] # set the current actors for the cutscene
var cutscene_data : Dictionary = {} # dictionary to hold parsed JSON cutscene data
var cutscene_step : int = 0 # iterates through the cutscene JSON data
var cutscene_finished : bool = false # true if cutscene is completed
var cutscene_timer : int = 0 # timer for the cutscene
var cutscene_paused : bool = false # if true then the cutscene will pause


func _ready():
	# get the cutscene data
	if story_beat != -4 and story_beat == Globals.game_stage:
		if cutscene_path.length() > 0:
			var json_data = FileAccess.get_file_as_string(cutscene_path)
			cutscene_data = JSON.parse_string(json_data)
			Globals.in_cutscene = true # the gmae in 'in cutscene'
			Globals.can_play = false # stop player movement
			Globals.game_ui.cutscene_node = self # set cutscene node
			get_parent().clear_characters() # run the function to clear all the actors
		else:
			print("ERROR: NO PATH SET FOR CUTSCENE")
			get_tree().quit() # quit the game after feeding the error
	else:
		queue_free() # delete self if not needed

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
	elif cutscene_step >= cutscene_data.size() and !cutscene_paused:
		# end the cutscene and clean up
		Globals.game_ui.cutscene_node = null # clear cutscene node

func cutscene_modes(mode):
	match mode:
		"timer":
			cutscene_timer = int(cutscene_data.values()[cutscene_step]["amount"]) # set the timer
			cutscene_step += 1 # advance to the next step
		"spawn":
			# set the position of the actor
			var actor_load = load(String(cutscene_data.values()[cutscene_step]["path"]))
			var actor = actor_load.instantiate()
			actor.dialogue_path = String(cutscene_data.values()[cutscene_step]["dialogue_path"])
			actor.dialogue_random = bool(cutscene_data.values()[cutscene_step]["dialogue_random"])
			actor.global_position = Vector2(float(cutscene_data.values()[cutscene_step]["start_x"]), float(cutscene_data.values()[cutscene_step]["start_y"]))
			actor.cutscene_mode = true # enable cutscene mode
			actor.face_dir = int(cutscene_data.values()[cutscene_step]["face_dir"]) # face direction
			actor.cutscene_parent = self # set cutscene parent as self
			get_parent().add_child(actor)
			cutscene_characters.append(actor) # add actor to the local characters array
			cutscene_step += 1 # advance to the next step
		"npc":
			# move the NPC
			cutscene_characters[int(cutscene_data.values()[cutscene_step]["actor"])].face_dir = int(cutscene_data.values()[cutscene_step]["face_dir"])
			var x_to = int(cutscene_data.values()[cutscene_step]["move_to_x"])
			var y_to = int(cutscene_data.values()[cutscene_step]["move_to_y"])
			cutscene_characters[int(cutscene_data.values()[cutscene_step]["actor"])].move_to = Vector2(x_to, y_to) # set the move_to Vector2
			cutscene_characters[int(cutscene_data.values()[cutscene_step]["actor"])].is_moving = true # set the NPC to move
			cutscene_step += 1 # advance to the next step
			cutscene_paused = true # pause the cutscene to allow character to move
		"dialogue":
			# play the set dialogue
			Globals.game_ui.dialogue_data["001"]["name"] = String(cutscene_data.values()[cutscene_step]["name"]) # set the dialogue data
			Globals.game_ui.dialogue_data["001"]["dialogue"] = String(cutscene_data.values()[cutscene_step]["dialogue"])
			Globals.game_ui.close_diag = bool(cutscene_data.values()[cutscene_step]["close"])
			Globals.game_ui.HUD_Mode = "DIALOGUE"
			cutscene_step += 1 # advance to the next step
			cutscene_paused = true # pause the cutscene to allow the dialogue to play
		"dialogue_player":
			Globals.game_ui.dialogue_data["001"]["name"] = Globals.player_name.to_upper() + ":" # set the dialogue data
			Globals.game_ui.dialogue_data["001"]["dialogue"] = String(cutscene_data.values()[cutscene_step]["dialogue"])
			Globals.game_ui.close_diag = bool(cutscene_data.values()[cutscene_step]["close"])
			Globals.game_ui.HUD_Mode = "DIALOGUE"
			cutscene_step += 1 # advance to the next step
			cutscene_paused = true # pause the cutscene to allow the dialogue to player
		"main_quest":
			# set a quest as directed
			Globals.main_quest = int(cutscene_data.values()[cutscene_step]["quest"])
			cutscene_step += 1 # advance to the next step
		"game_stage":
			# change the gamestage
			Globals.game_stage = int(cutscene_data.values()[cutscene_step]["stage"])
			cutscene_step += 1 # advance to the next step
		"player":
			# controls the player (who is not in the cutscene actors array)
			cutscene_step += 1 # advance to the next step
		"music":
			# plays an OST track
			cutscene_step += 1 # advance to the next step
		"sfx":
			# plays a sound effect
			cutscene_step += 1 # advance to the next step
		"fin":
			# the end of the cutscene
			Globals.can_play = true # restore control back to the player
			Globals.in_cutscene = false # stop the cutscene
			print("Cutscene completed")
			queue_free() # delete this instance of the cutscene system

