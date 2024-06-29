extends Node
# NPC TEMPLATE
# the base template for each NPC in the game
@onready var RNG = RandomNumberGenerator.new() # random number generator
@export var npc_name : String = "NPC"
@export var dialogue_file : String = "" # the json file path for the game
@export var start_positions : Array = [] # the different start positions
@export var change_start_position : bool = false # if the NPC should start at a random position pulled from start_positions
@export var will_wonder : bool = false # if true the NPC will move at random intervals
@export var npc_story_beats : Array = [] # GLOBAL game_stage that relate to the NPC
var is_active : bool = false # if the NPC is 'active' (player ray is colliding)
var move_timer : float = 100.0 # move countdown timer
var move_dir : int = 0 # typical clockwise (0 = up, 1, 2, 3 = Left)
var move_speed : float = 0


func _ready():
    RNG.randomize() # seed the random
    # check the story beats
    if npc_story_beats.size() > 0:
        for n in npc_story_beats.size():
            if npc_story_beats[n] == Globals.game_stage:
                change_start_position = false # stop the NPC from spawning randomly
                will_wonder = false # turn off wondering
    # check if the NPC should spawn randomly
    if change_start_position and start_positions.size() > 0:
        #var random_position = Vector2(RNG.randi_range(0, start_positions.size()))
        #print(str(random_position))
        #self.position = Vector2(random_position.x, random_position.y)
        pass

func _process(_delta):
    if is_active:
        if Input.is_action_just_pressed("td_DEBUG"):
            print("I AM RENOILT")