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
# DIALOGUE CHOICE HUD
# YES/NO
# CURSOR
# HUD variables
var HUD_Mode : String = "GAME" # MAIN_MENU, GAME, DIALOGUE
# dialogue variables
var dialogue_data : Dictionary = {} # holds the dialogue data


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

func _process(_delta):
	update_hud() # keep the HUD up to date with what it needs to display


func update_hud():
	if LEVEL.text != Globals.current_stage: LEVEL.text = Globals.current_Stage # update the current stage
	if HUD_Mode == "GAME":
		# this is the main hud for the game
		# this shows the player/party stats
		GAME_HUD.visible = true # show the GAME HUD
		DIALOGUE_HUD.visible = false # hide the dialogue HUD
		# player
		PL_HP.text = str(Globals.player_hp, "/", Globals.player_max_hp)
		PL_MP.text = str(Globals.player_mp, "/", Globals.player_max_mp)
		PL_LEVEL.text = str(Globals.player_level)
		# member two
		# member three
	elif HUD_Mode == "DIALOGUE":
		# the dialogue/message text for the game is displayed here
		GAME_HUD.visible = false # hide the game HUD
		DIALOGUE_HUD.visible = true # show the dialogue HUD
	elif HUD_Mode == "MAIN_MENU":
		# the main menu only happens at the beginning of the game
		pass