extends Node
# INTERIOR SCENE TEMPLATE
@export var stage_name : String = "DEFAULT" # what the HUD will display (Globals.current_stage)
@export var start_pos : Array = [] # start positions
var check : bool = false # used as a check


func _ready():
	Globals.current_stage = stage_name # update the displayed 'stage name' for the UI\
	start_position() # run the start position function

func _process(_delta):
	pass


func start_position():
	# iterate through the start_positions dictionary and move the player if need be
	if start_pos.size() > 0:
		for n in start_pos.size():
			if start_pos[n]["stage"] == Globals.game_stage:
				$Player.global_position = start_pos[n]["position"]
				break;

func clear_characters():
	for n in $Characters.get_children():
		$Characters.remove_child(n) # remove the child
