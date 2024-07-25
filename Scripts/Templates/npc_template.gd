extends Node
# NPC TEMPLATE
# the base template for each NPC in the game
@onready var RNG = RandomNumberGenerator.new() # random number generator
@export var npc_name : String = "NPC" # name of the NPC
@export var shop_keeper : bool = false # if this NPC is a shopkeeper
@export var shop_items : Dictionary = {} # list of items the shopkeeper sells
@export var quest_giver : bool = false # if this NPC gives any quests
@export var related_quests : Dictionary = {} # list of quests this NPC gives out
@export var dialogue_branch : bool = false # if true then this NPC has 'branching' dialogue
@export_multiline var dialogue_test : Dictionary # the dialogue data
@export var change_start_position : bool = false # if the NPC should start at a random position pulled from start_positions
@export var start_positions : Array = [] # the different start positions
@export var will_wonder : bool = false # if true the NPC will move at random intervals
var is_active : bool = false # if the NPC is 'active' (player ray is colliding)
var move_timer : float = 100.0 # move countdown timer
var is_moving : bool = false # if the NPC is moving
var move_dir : int = 0 # typical clockwise (0 = up, 1, 2, 3 = Left)
var face_dir : int = 0 # typical clockwise (0 = up, 1, 2, 3 = Left)
var move_speed : float = 0.50 # NPC movement speed
var move_to : Vector2 = Vector2.ZERO
var dialogue_data : Dictionary = {} # holds the dialogue data
var talked_to : bool = false # if the NPC has been talked to already this story beat


func _ready():
	RNG.randomize() # seed the random


func npc_movement():
	# npc movement function
	pass


func _on_body_entered(body):
	if body.is_in_group("PLAYER"):
		is_active = true # NPC is 'active'

func _on_body_exited(body):
	if body.is_in_group("PLAYER"):
		is_active = false # NPC is no longer 'active'
