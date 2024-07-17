extends Node2D
# CUTSCENE SYSTEM
# reads the cutscene data from a JSON file and then the actors move accordingly
@export var story_beat : int = -4 # set the corresponding story 'beat'
@export var file_path : String = "res://JSON/Cutscenes/renoilt_open.json" # path to the JSON file
var cutscene_data : Dictionary = {} # stores the data read from the JSON file
var cutscene_step : int = 0 # iterates through the cutscene JSON data
var cutscene_finished : bool = false # true if cutscene is completed
var cutscene_timer : int = 0 # timer for the cutscene


func _ready():
	# JSON data test
	pass
