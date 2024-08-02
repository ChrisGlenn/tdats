extends CanvasLayer
# GAME HUD
# the main HUD for the game. It is persistent and autloads when the game starts
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
@onready var DIALOGUE_CHOICE = $DialogueChoice
@onready var DIALOGUE_YES = $DialogueChoice/Yes_One
@onready var DIALOGUE_NO = $DialogueChoice/No_Two

# HUD variables
var HUD_Mode : String = "GAME" # MAIN_MENU, GAME, DIALOGUE
# dialogue variables
var cutscene_node # holds the cutscene node
var dialogue_data : Dictionary = {"001" : {"name": "DEBUG","dialogue": "DEBUG DIALOGUE","close": true}} # holds the dialogue data
var diag_show_choice : bool = false # if true the dialogue choice screen will show
var diag_pos : int = 0 # the position in the dialogue data
var diag_next : bool = true # if the dialogue text is done 'typing' and ready to advance
var diag_timer : int = 3 # timer countdown between displaying a character
var diag_choice_pos : int = 0 # 0 is left/yes 1 is right/no
var close_diag : bool = false # this will close the dialogue during a cutscene


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
		DIALOGUE_CHOICE.visible = false # hide the dialogue choice HUD
		Globals.in_dialogue = false # return 
		# player
		PL_HP.text = str(Globals.player_hp, "/", Globals.player_max_hp)
		PL_MP.text = str(Globals.player_mp, "/", Globals.player_max_mp)
		PL_LEVEL.text = str(Globals.player_level)
		# member two
		# member three
	elif HUD_Mode == "DIALOGUE":
		if dialogue_data.size() > 0:
			# the dialogue/message text for the game is displayed here
			Globals.can_play = false # stop the player from playing to display the dialogue
			Globals.in_dialogue = true
			GAME_HUD.visible = false # hide the game HUD
			if diag_show_choice:
				DIALOGUE_HUD.visible = false # hide the previous dialogue
				DIALOGUE_CHOICE.visible = true # show the dialogue choice
			else:
				DIALOGUE_HUD.visible = true # show the previous dialogue
				DIALOGUE_CHOICE.visible = false # hide the dialogue choice
				if diag_pos < dialogue_data.size():
					DIALOGUE_NAME.text = dialogue_data.values()[diag_pos]["name"] # set name
					DIALOGUE_TEXT.text = dialogue_data.values()[diag_pos]["dialogue"] # set the dialogue text
					close_diag = dialogue_data.values()[diag_pos]["close"] # set the close dialogue check
					type_dialogue(clock)
					if Input.is_action_just_pressed("td_A"):
						if diag_next: 
							DIALOGUE_TEXT.visible_characters = 0 # reset the visible characters
							diag_pos += 1 # advance to the next dialogue line or close the dialogue
				else:
					if close_diag:
						if Globals.in_cutscene and cutscene_node: cutscene_node.cutscene_paused = false # unpause the cutscene
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
		pass
	elif HUD_Mode == "TRANSITION":
		# hide all the huds
		GAME_HUD.visible = false
		DIALOGUE_HUD.visible = false
		DIALOGUE_CHOICE.visible = false

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
