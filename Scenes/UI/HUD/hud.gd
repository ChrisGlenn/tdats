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
# DIALOGUE CHOICE HUD
# YES/NO
# CURSOR
# HUD variables
var HUD_Mode : String = "GAME" # MAIN_MENU, GAME, DIALOGUE
# dialogue variables
var dialogue_data : Dictionary = {} # holds the dialogue data
var dialogue_choice_data : Dictionary = {} # holds the dialogue choice data
var diag_show_choice : bool = false # if true the dialogue choice screen will show
var diag_pos : int = 0 # the position in the dialogue data
var diag_next : bool = true # if the dialogue text is done 'typing' and ready to advance
var diag_timer : int = 3 # timer countdown between displaying a character
var diag_choice_pos : int = 0 # 0 is left/yes 1 is right/no


func _ready():
	# GAME HUD LOADING
	LEVEL.text = Globals.current_stage
	PL_NAME.text = Globals.player_name
	PL_HP.text = str(Globals.player_hp, "/", Globals.player_max_hp)
	PL_MP.text = str(Globals.player_mp, "/", Globals.player_max_mp)
	PL_LEVEL.text = str(Globals.player_level)
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
		# player
		PL_HP.text = str(Globals.player_hp, "/", Globals.player_max_hp)
		PL_MP.text = str(Globals.player_mp, "/", Globals.player_max_mp)
		PL_LEVEL.text = str(Globals.player_level)
		# member two
		# member three
	elif HUD_Mode == "DIALOGUE":
		# the dialogue/message text for the game is displayed here
		Globals.can_play = false # stop the player from playing to display the dialogue
		GAME_HUD.visible = false # hide the game HUD
		if diag_show_choice:
			DIALOGUE_HUD.visible = false # hide the previous dialogue
			DIALOGUE_CHOICE.visible = true # show the dialogue choice
			if diag_pos < dialogue_data.size():
				type_dialogue(clock) # play the type out animation
			else:
				# the player has come to the end of the dialogue if they try to advance
				# the dialogue will close and the HUD will revert back to GAME
				hud_switch("GAME")
		else:
			DIALOGUE_HUD.visible = true # show the dialogue HUD
			DIALOGUE_CHOICE.visible = false # hide the dialogue choice
	elif HUD_Mode == "MAIN_MENU":
		# the main menu only happens at the beginning of the game
		pass

func hud_switch(hud_mode):
	# this will make necessary updates for when switching HUD_Mode(s)
	dialogue_data.clear() # clear the dialogue data
	dialogue_choice_data.clear() # clear the dialogue choice data
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