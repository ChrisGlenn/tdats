extends Node
# NPC TEMPLATE
# the base template for each NPC in the game
@onready var RNG = RandomNumberGenerator.new() # random number generator
@onready var SPRITE = $AnimatedSprite2D # animated sprite
@export var npc_name : String = "NPC" # name of the NPC
@export_group("NPC Dialogue") # set up NPC dialogue group
@export var dialogue_random : bool = false # if true the dialogue will be selected randomly
@export var dialogue_path : String = "" # path to the JSON file
@export_group("NPC Options") # set up NPC options group
@export var shop_keeper : bool = false # if this NPC is a shopkeeper
@export var shop_items : Dictionary = {} # list of items the shopkeeper sells
@export var has_schedule : bool = false # if true the NPC will have a schedule they will follow
@export var schedule : Dictionary = {} # schedule for the NPC
@export var has_quest : bool = false # if this NPC has a main quest attached to it
@export var quest_ref : int = -4 # the reference for the quest
@export var has_side_quest : bool = false # if this NPC has a side quest attached to them
@export var side_quest_ref : int = -4 # the reference for the side quest
var cutscene_mode : bool = false # if the NPC is part of a cutscene or not
var cutscene_parent # holds the cutscene parent
var is_active : bool = false # if the NPC is 'active' (player ray is colliding)
var move_timer : float = 100.0 # move countdown timer
var is_moving : bool = false # if the NPC is moving
var face_dir : int = 2 # typical clockwise (0 = up, 1, 2, 3 = Left DEFAULTS TO DOWN)
var move_speed : float = 43.0 # NPC movement speed
var move_to : Vector2 = Vector2.ZERO # coord to move to
var dialogue_data : Dictionary = {} # holds the dialogue data
var random_diag_pos : int # holds the random dialogue position


func _ready():
	RNG.randomize() # seed the random
	# parse the JSON dialogue
	if !cutscene_mode:
		if dialogue_path.length() > 0:
			var json_data = FileAccess.get_file_as_string(dialogue_path)
			dialogue_data = JSON.parse_string(json_data)
			for n in range(dialogue_data.size()-1, -1, -1):
				if dialogue_data.values()[n]["stage"] != Globals.game_stage:
					dialogue_data.erase(dialogue_data.keys()[n]) # delete the entry from the dialogue
		else:
			print("ERROR: NO DIALOGUE PATH SET FOR ", npc_name)
			get_tree().quit() # quit the game after spitting out the error
	# set NPC face direction
	if face_dir == 0: SPRITE.play("walkUp") # walk up
	elif face_dir == 1: SPRITE.play("walkRight") # walk right
	elif face_dir == 2: SPRITE.play("walkDown") # walk down
	elif face_dir == 3: SPRITE.play("walkLeft") # walk left

func _process(_delta):
	npc_interact() # interaction function

func _physics_process(delta):
	npc_movement(delta) # npc movement function


func npc_movement(clock):
	# npc movement function
	if cutscene_mode:
		if cutscene_parent:
			if is_moving:
				if face_dir == 0:
					# move up
					SPRITE.play("walkUp") # change the animation
					if self.global_position.y > move_to.y:
						self.position.y -= move_speed * clock # move
					else:
						self.global_position.y = move_to.y # make sure the NPC stops at set Y coord
						cutscene_parent.cutscene_paused = false # 'unpause' the cutscene
						is_moving = false # stop movement
				elif face_dir == 1:
					SPRITE.play("walkRight") # change the animation
					# move right
					if self.global_position.x < move_to.x:
						self.position.x += move_speed * clock # move
					else:
						self.global_position.x = move_to.x # make sure the NPC stops at set Y coord
						cutscene_parent.cutscene_paused = false # 'unpause' the cutscene
						is_moving = false # stop movement
				elif face_dir == 2:
					SPRITE.play("walkDown") # change the animation
					# move down
					if self.global_position.y < move_to.y:
						self.position.y += move_speed * clock # move
					else:
						self.global_position.y = move_to.y # make sure NPC stops at set Y coord
						cutscene_parent.cutscene_paused = false # 'unpase' the cutscene
						is_moving = false # stop movement
				elif face_dir == 3:
					SPRITE.play("walkLeft") # change the animation
					# move left
					if self.global_position.x > move_to.x:
						self.position.x -= move_speed * clock # move
					else:
						self.global_position.x = move_to.x # make sure the NPC stops at set Y coord
						cutscene_parent.cutscene_paused = false # 'unpause' the cutscene
						is_moving = false # stop movement
		else:
			print("ERROR: NO CUTSCENE PARENT SET FOR ", npc_name)
		if !Globals.in_cutscene: 
			cutscene_end() # parese dialogue and other end of cutscene stuff
			cutscene_mode = false # return to normal
	else:
		# NPC SCHEDULE
		# this is a random pick
		if has_schedule:
			pass
		else:
			pass
	# set the animation frames
	SPRITE.frame = Globals.frame_ctrl # sync to frame control

func npc_interact():
	# checks for any input if the NPC is active
	if is_active and !cutscene_mode:
		# check for input and start the dialogue
		if Input.is_action_just_pressed("td_A"):
			if dialogue_random:
				Globals.game_ui.dialogue_data["001"]["name"] = dialogue_data.values()[random_diag_pos]["name"]
				Globals.game_ui.dialogue_data["001"]["dialogue"] = dialogue_data.values()[random_diag_pos]["dialogue"]
				Globals.game_ui.close_diag = true # close after random dialogue
				random_diag_pos = RNG.randi_range(0, dialogue_data.size()-1) # set random dialogue position
			else:
				Globals.game_ui.dialogue_data = dialogue_data
			Globals.game_ui.HUD_Mode = "DIALOGUE" # switch hud mode to dialogue

func cutscene_end():
	# check to parse the dialogue data incase this is a 'cutscene' actor NPC
	if dialogue_data.size() == 0:
		if dialogue_path.length() > 0:
			var json_data = FileAccess.get_file_as_string(dialogue_path)
			dialogue_data = JSON.parse_string(json_data)
			for n in range(dialogue_data.size()-1, -1, -1):
				if dialogue_data.values()[n]["stage"] != Globals.game_stage:
					dialogue_data.erase(dialogue_data.keys()[n]) # delete the entry from the dialogue
		else:
			print("ERROR: NO DIALOGUE PATH SET FOR ", npc_name)
			get_tree().quit() # quit the game after spitting out the error

func _on_body_entered(body):
	if body.is_in_group("PLAYER"):
		print("ENETERED")
		is_active = true # NPC is 'active'
		if dialogue_random: 
			random_diag_pos = RNG.randi_range(0, dialogue_data.size()-1) # set random dialogue position

func _on_body_exited(body):
	if body.is_in_group("PLAYER"):
		is_active = false # NPC is no longer 'active'
