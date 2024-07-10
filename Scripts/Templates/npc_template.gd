extends Node
# NPC TEMPLATE
# the base template for each NPC in the game
@onready var RNG = RandomNumberGenerator.new() # random number generator
@export var npc_name : String = "NPC" # name of the NPC
@export var start_positions : Array = [] # the different start positions
@export var change_start_position : bool = false # if the NPC should start at a random position pulled from start_positions
@export var story_start_positions : Array = [] # start positions for story beats
@export var set_story_start : bool = true # defaults to true
@export var will_wonder : bool = false # if true the NPC will move at random intervals
@export var npc_story_beats : Array = [] # GLOBAL game_stage that relate to the NPC
var cutscene : bool = false # if the NPC is in 'cutscene' mode
var is_active : bool = false # if the NPC is 'active' (player ray is colliding)
var move_timer : float = 100.0 # move countdown timer
var is_moving : bool = false # if the NPC is moving
var move_dir : int = 0 # typical clockwise (0 = up, 1, 2, 3 = Left)
var face_dir : int = 0 # typical clockwise (0 = up, 1, 2, 3 = Left)
var move_speed : float = 0.50 # NPC movement speed


func _ready():
	RNG.randomize() # seed the random
	# check the story beats
	if npc_story_beats.size() > 0:
		for n in npc_story_beats.size():
			if npc_story_beats[n] == Globals.game_stage:
				self.position = Vector2(story_start_positions[Globals.game_stage].x, story_start_positions[Globals.game_stage].y) # set story start position
				change_start_position = false # stop the NPC from spawning randomly
				will_wonder = false # turn off wondering
				break # stop the loop
	# check if the NPC should spawn randomly
	if change_start_position and start_positions.size() > 0:
		var random_array_position = RNG.randi_range(0, start_positions.size())
		self.position = Vector2(start_positions[random_array_position].x, start_positions[random_array_position].y)

func _process(_delta):
	if cutscene:
		pass
	else:
		if is_active:
			# interatct/start dialogue
			# DEBUG
			if Input.is_action_just_pressed("td_DEBUG"):
				print("I AM RENOILT")


func npc_movement():
	# npc movement function
	pass


func _on_body_entered(body):
	if body.is_in_group("PLAYER"):
		is_active = true # the NPC is now active

func _on_body_exited(body):
	if body.is_in_group("PLAYER"):
		is_active = false # the NPC is now false
