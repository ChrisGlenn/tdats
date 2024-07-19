extends Node2D
# BRIDGE
# the bridge of the ship
onready var KIDA = preload("res://Scenes/Characters/Kida/Kida.tscn")
onready var DIAG = preload("res://Scenes/UI/Dialogue/Dialogue.tscn")
onready var TRANSOUT = preload("res://Scenes/UI/TransOut/TransOut.tscn")
onready var CUTCAM = $CutsceneCam
export(Array) var cutscene_fPaths = [] # json filepath for cutscenes
var cutscene_file = File.new() # cutscene file
var cutscene_data = {} # dictionary to hold cutscene data
var cutscene_step = 0 # used to iterate through cutscene JSON
var cutscene_finished = false # if the cutscene is done
var cutscene_move = false # if the cutscene is moving along
var cutscene_actors = [] # array to hold the actors
var cs_diag_data = {"001": {"name": "","portrait": 0,"dialogue": ""}} # holds the parsed RND dialogue
var cut_timer = 0 # cutscene timer
var timer_ctrl = 100 # timer control


# SYSTEM FUNCTIONS
func _ready():
	Globals.last_room = "BRIDGE" # set last room
	# check if there is a matching story for the bridge
	if cutscene_fPaths[Globals.story].length() > 0:
		Globals.cutscene = true
	# load the cutscene if so otherwise spawn NPC's and player
	if Globals.cutscene:
		CUTCAM.current = true
		# load the cutscene path and print
		cutscene_file.open(cutscene_fPaths[Globals.story], cutscene_file.READ)
		cutscene_data = parse_json(cutscene_file.get_as_text())
		cutscene_file.close()
	else:
		set_kida_position()

func _process(delta):
	# check the timer and if it's empty then iterate through the cutscene
	# spawn file
	if cut_timer > 0:
		cut_timer -= timer_ctrl * delta
	else:
		cutscene()


# CUSTOM FUNCTIONS
func cutscene():
	# iterate through the cutscene JSON file and spawn the actors needed
	if cutscene_step < cutscene_data.size():
		if !cutscene_move:
			# timer
			if cutscene_data.values()[cutscene_step]["mode"] == "timer":
				cut_timer = int(cutscene_data.values()[cutscene_step]["timer"])
				cutscene_step += 1 # increment step
			# camera spawn
			elif cutscene_data.values()[cutscene_step]["mode"] == "cam_start":
				$CutsceneCam.global_position = Vector2(float(cutscene_data.values()[cutscene_step]["start_x"]), float(cutscene_data.values()[cutscene_step]["start_y"]))
				cutscene_step += 1 # increment step
			# NPC spawn
			elif cutscene_data.values()[cutscene_step]["mode"] == "spawn":
				var npc_load = load(cutscene_data.values()[cutscene_step]["path"])
				var npc = npc_load.instance()
				npc.global_position = Vector2(float(cutscene_data.values()[cutscene_step]["start_x"]),float(cutscene_data.values()[cutscene_step]["start_y"]))
				npc.stationary = bool(cutscene_data.values()[cutscene_step]["stationary"])
				npc.start_dir = int(cutscene_data.values()[cutscene_step]["dir"])
				npc.cutscene = true
				$YSort.add_child(npc)
				cutscene_actors.append(npc)
				cutscene_step += 1 # increment step
			# camera movement
			elif cutscene_data.values()[cutscene_step]["mode"] == "camera":
				CUTCAM.dir = int(cutscene_data.values()[cutscene_step]["dir"])
				CUTCAM.x_to = int(cutscene_data.values()[cutscene_step]["x_to"])
				CUTCAM.y_to = int(cutscene_data.values()[cutscene_step]["y_to"])
				CUTCAM.move_speed = int(cutscene_data.values()[cutscene_step]["move_speed"])
				CUTCAM.moving = true # set cutscene camera to move
				cutscene_move = true # set cutscene move to true to await cam movement
			# npc movement
			elif cutscene_data.values()[cutscene_step]["mode"] == "npc":
				var npc_cont = cutscene_actors[int(cutscene_data.values()[cutscene_step]["npc"])]
				npc_cont.creator = self # set the creator to the root scene
				npc_cont.cutscene = true # set the cutscene mode for the NPC to true
				npc_cont.move_dir = int(cutscene_data.values()[cutscene_step]["dir"])
				npc_cont.coord = int(cutscene_data.values()[cutscene_step]["coord"])
				npc_cont.moving = true # set npc to moving
				cutscene_move = true # set the cutscene move to true to await npc movement
			# cutscene dialogue
			elif cutscene_data.values()[cutscene_step]["mode"] == "dialogue":
				var diag = DIAG.instance()
				cs_diag_data["001"]["name"] = String(cutscene_data.values()[cutscene_step]["name"])
				cs_diag_data["001"]["portrait"] = int(cutscene_data.values()[cutscene_step]["portrait"])
				cs_diag_data["001"]["dialogue"] = String(cutscene_data.values()[cutscene_step]["dialogue"])
				diag.creator = self # set self as creator
				diag.diag_type = "B" # set to B to avoid feeding from a file
				diag.diag_data = cs_diag_data # set the dialogue data to display
				diag.close_diag = bool(cutscene_data.values()[cutscene_step]["close"])
				add_child(diag) # add the dialogue
				cutscene_move = true # set the cutscene move to true to await dialogue
			# cutscene updates (sleep, ect.)
			elif cutscene_data.values()[cutscene_step]["mode"] == "update":
				Globals.sleep = bool(cutscene_data.values()[cutscene_step]["sleep"])
				Globals.start_level = bool(cutscene_data.values()[cutscene_step]["level_start"])
				cutscene_step += 1 # move on to the next step
			# cutscene OVER
			elif cutscene_data.values()[cutscene_step]["mode"] == "close":
				var tout = TRANSOUT.instance()
				tout.level_to = cutscene_data.values()[cutscene_step]["level_to"]
				tout.adv_story = true # set to increment story
				Globals.cutscene = false # close the cutscene out
				add_child(tout)
			# ERROR
			else:
				print("ERROR: No viable cutscene mode set")

func inc_cutscene():
	# used by other scenes to move cutscene along
	cutscene_move = false
	cutscene_step += 1

func set_kida_position():
	# sets Kida's start position on the map
	var kida = KIDA.instance()
	kida.global_position = Vector2(160,118)
	kida.start_dir = 1 # face up
	$YSort.add_child(kida)
