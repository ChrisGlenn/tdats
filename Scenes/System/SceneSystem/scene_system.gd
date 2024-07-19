extends Node2D
# CUTSCENE SYSTEM
# reads the cutscene data from a JSON file and then the actors move accordingly
@export var story_beat : int = -4 # set the corresponding story 'beat'
@export var json_path : String = "" # file path to the cutscene JSON file
var cutscene_data : Dictionary = {} # dictionary to hold parsed JSON cutscene data
var cutscene_step : int = 0 # iterates through the cutscene JSON data
var cutscene_finished : bool = false # true if cutscene is completed
var cutscene_timer : int = 0 # timer for the cutscene


func _ready():
	# parse JSON file data into cutscene_data dictionary
	if json_path:
		var file_data = FileAccess.get_file_as_string(json_path) # pull the data from the file as a string
		cutscene_data = JSON.parse_string(file_data) # parse the string file_data into a new dictionary
	else:
		# if there is no cutscene file path set then send out an error
		print("ERROR: NO FILE PATH SET FOR CUTSCENE")
