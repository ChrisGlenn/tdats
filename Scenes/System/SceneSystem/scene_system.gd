extends Node2D
# CUTSCENE SYSTEM
# reads the cutscene data from a JSON file and then the actors move accordingly
@export var story_beat : int = -4 # set the corresponding story 'beat'
@export var cutscene_characters : Array = [] # set the current actors for the cutscene
var cutscene_data : Dictionary = {} # dictionary to hold parsed JSON cutscene data
var cutscene_step : int = 0 # iterates through the cutscene JSON data
var cutscene_finished : bool = false # true if cutscene is completed
var cutscene_timer : int = 0 # timer for the cutscene


func _ready():
	# get the cutscene data
	if story_beat != -4:
		cutscene_data = Cutscenes.set_cutscene(story_beat)
		
