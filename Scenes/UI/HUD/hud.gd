extends CanvasLayer
# GAME HUD
# the main HUD for the game. It is persistent and autloads when the game starts
@onready var PAUSED = preload("res://Scenes/UI/Pause/pause.tscn")
@onready var LOCATION = $LocationLabel
# main hud showing party members
@onready var GAME_HUD = $GameHUD
@onready var LEVEL = $LocationLabel
@onready var PL_NAME = $GameHUD/Player/PlayerName
@onready var PL_HP = $GameHUD/Player/PlayerHP
@onready var PL_MP = $GameHUD/Player/PlayerMP
@onready var PL_LEVEL = $GameHUD/Player/PlayerLevel
@onready var MEM_TWO = $GameHUD/MemberTwo
@onready var MEM_TWO_NAME = $GameHUD/MemberTwo/MemTwoName
@onready var MEM_TWO_HP = $GameHUD/MemberTwo/MemTwoHP
@onready var MEM_TWO_MP = $GameHUD/MemberTwo/MemTwoMP
@onready var MEM_TWO_LEVEL = $GameHUD/MemberTwo/MemTwoLevel
@onready var MEM_THREE = $GameHUD/MemberThree
@onready var MEM_THREE_NAME = $GameHUD/MemberThree/MemThreeName
@onready var MEM_THREE_HP = $GameHUD/MemberThree/MemThreeHP
@onready var MEM_THREE_MP = $GameHUD/MemberThree/MemThreeMP
@onready var MEM_THREE_LEVEL = $GameHUD/MemberThree/MemThreeLevel
@onready var DIALOGUE_HUD = $Dialogue
@onready var DIALOGUE_NAME = $Dialogue/DiagNameLabel
@onready var DIALOGUE_TEXT = $Dialogue/DiagText
@onready var MENU = $GameMenu
@onready var MENU_CURSOR = $GameMenu/MenuCursor
# HUD variables
var HUD_Mode : String = "GAME" # MAIN_MENU, GAME, DIALOGUE, MENU
# dialogue variables
var cutscene_node # holds the cutscene node
var dialogue_npc # holds the NPC that is currently interacting with the player (dialogue only, not for cutscene usage!!!)
var dialogue_data : Dictionary = {"001" : {"name": "DEBUG","dialogue": "DEBUG DIALOGUE","close": true}} # holds the dialogue data
var diag_pos : int = 0 # the position in the dialogue data
var diag_next : bool = true # if the dialogue text is done 'typing' and ready to advance
var diag_timer : int = 3 # timer countdown between displaying a character
var close_diag : bool = false # this will close the dialogue during a cutscene
# menu variables
var menu_cur_pos : int = 0 # the menu cursor position


func _ready():
	# GAME HUD LOADING
	Globals.game_ui = self # set the Global for the UI as self
	LEVEL.text = Globals.current_stage
	PL_NAME.text = Globals.player_name
	PL_HP.text = str(Globals.player_hp, "/", Globals.player_max_hp)
	PL_MP.text = str(Globals.player_mp, "/", Globals.player_max_mp)
	PL_LEVEL.text = str(Globals.player_level)
	# dialogue
	DIALOGUE_TEXT.visible_characters = 0 # set visible characters to 0
	# check party size to display member information
	if Globals.party_size == 1:
		MEM_TWO.visible = false # hide
		MEM_THREE.visible = false # hide

func _process(delta):
	update_hud(delta) # keep the HUD up to date with what it needs to display


func update_hud(clock):
	if LEVEL.text != Globals.current_stage: LEVEL.text = Globals.current_stage # update the current stage
	if HUD_Mode == "GAME":
		# this is the main hud for the game
		# this shows the player/party stats
		GAME_HUD.visible = true # show the GAME HUD
		DIALOGUE_HUD.visible = false # hide the dialogue HUD
		MENU.visible = false # hide the menu
		Globals.in_dialogue = false # return 
		if menu_cur_pos != 0: menu_cur_pos = 0 # reset the menu cursor position
		# player
		PL_HP.text = str(Globals.player_hp, "/", Globals.player_max_hp)
		PL_MP.text = str(Globals.player_mp, "/", Globals.player_max_mp)
		PL_LEVEL.text = str(Globals.player_level)
		# member two
		# member three
		# INPUT MONITORING
		# pause menu
		if Input.is_action_just_pressed("td_START"):
			if !get_tree().paused:
				var paused = PAUSED.instantiate()
				get_parent().add_child(paused)
				get_tree().paused = true # pause the game
		# game menu
		if Input.is_action_just_pressed("td_SELECT"):
			HUD_Mode = "MENU" # switch to menu mode
	elif HUD_Mode == "DIALOGUE":
		if dialogue_data.size() > 0:
			# the dialogue/message text for the game is displayed here
			Globals.can_play = false # stop the player from playing to display the dialogue
			Globals.in_dialogue = true
			GAME_HUD.visible = false # hide the game HUD
			DIALOGUE_HUD.visible = true # show the previous dialogue
			MENU.visible = false # hide the menu
			if diag_pos < dialogue_data.size():
				DIALOGUE_NAME.text = dialogue_data.values()[diag_pos]["name"] # set name
				DIALOGUE_TEXT.text = dialogue_data.values()[diag_pos]["dialogue"] # set the dialogue text
				close_diag = dialogue_data.values()[diag_pos]["close"] # set the close dialogue check
				type_dialogue(clock)
				if Input.is_action_just_pressed("td_A"):
					if diag_next: 
						# check if a side quest needs to be updated
						if dialogue_data.values()[diag_pos]["inc_quest"] == true:
							var side_quest_ref = int(dialogue_data.values()[diag_pos]["side_quest"]) # increment the side quest
							Globals.side_quest[side_quest_ref] += 1 # increment the side quest status
							print(Globals.side_quest) # DEBUG print
						DIALOGUE_TEXT.visible_characters = 0 # reset the visible characters
						diag_pos += 1 # advance to the next dialogue line or close the dialogue
			else:
				if close_diag:
					if Globals.in_cutscene and cutscene_node: cutscene_node.cutscene_paused = false # unpause the cutscene
					if dialogue_npc: dialogue_npc.refresh_dialogue() # refresh the NPC's dialogue
					Globals.can_play = true # return control to the player
					hud_switch("GAME")
				else: 
					if Globals.in_cutscene and cutscene_node: cutscene_node.cutscene_paused = false # unpause the cutscene
					hud_switch("TRANSITION")
		else:
			print("ERROR: NO DIALOGUE DATA IS SET: ", self)
			get_tree().quit() # quit the game after displaying the error for debugging
	elif HUD_Mode == "MAIN_MENU":
		# the main menu only happens at the beginning of the game
		GAME_HUD.visible = false
		MENU.visible = false # hide the menu
		DIALOGUE_HUD.visible = false
	elif HUD_Mode == "TRANSITION":
		# hide all the huds
		GAME_HUD.visible = false
		MENU.visible = false # hide the menu
		DIALOGUE_HUD.visible = false
	elif HUD_Mode == "MENU":
		GAME_HUD.visible = false
		MENU.visible = true # show the menu
		DIALOGUE_HUD.visible = false
		get_tree().paused = true # pause the game
		menu_cursor() # cursor movement function

func menu_cursor():
	# controls the cursor movement function along with player input to redirect the user
	# to the selected menu item
	if menu_cur_pos < 4:
		if Input.is_action_just_pressed("td_DOWN"):
			menu_cur_pos += 1 # increment cursor position
	if menu_cur_pos > 0:
		if Input.is_action_just_pressed("td_UP"):
			menu_cur_pos -= 1 # decrement cursor position
	# interaction
	if Input.is_action_just_pressed("td_A"):
		if menu_cur_pos == 4:
			get_tree().paused = false # unpause the game
			HUD_Mode = "GAME" # return to the main UI mode
	# set cursor position
	match menu_cur_pos:
		0:
			# equipment
			MENU_CURSOR.global_position = Vector2(34,40)
		1:
			# inventory
			MENU_CURSOR.global_position = Vector2(34,54)
		2:
			# status
			MENU_CURSOR.global_position = Vector2(34,68)
		3:
			# quit game
			MENU_CURSOR.global_position = Vector2(34,82)
		4:
			# close menu
			MENU_CURSOR.global_position = Vector2(34,98)

func hud_switch(hud_mode):
	# this will make necessary updates for when switching HUD_Mode(s)
	dialogue_data = {"001" : {"name": "DEBUG","dialogue": "DEBUG DIALOGUE","close": true}} # reset to default
	diag_pos = 0 # reset dialogue position
	HUD_Mode = hud_mode # change the HUD mode to the requested mode

func type_dialogue(clock):
	# types out the dialogue
	if DIALOGUE_TEXT.visible_characters < DIALOGUE_TEXT.get_total_character_count():
		diag_next = false # stop player from advancing the dialogue
		if diag_timer > 0:
			diag_timer -= Globals.timer_ctrl * clock # decrement timer
		else:
			DIALOGUE_TEXT.visible_characters += 1 # iterate to next character
			diag_timer = 3 # reset the dialogue timer
	else:
		diag_next = true # allow the player to advance to the next dialogue
