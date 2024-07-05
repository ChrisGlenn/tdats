extends CanvasLayer
# GAME HUD
# the main HUD for the game. It is persistent and autloads when the game starts
@onready var LOCATION = $LocationLabel
# main hud showing party members
@onready var GAME_HUD = $GameHUD
@onready var PL_NAME = $GameHUD/PlayerName
@onready var PL_HP = $GameHUD/PlayerHP
@onready var PL_MP = $GameHUD/PlayerMP
@onready var PL_LEVEL = $GameHUD/PlayerLevel
# HUD variables
var HUD_Mode : String = "GAME" # MAIN_MENU, GAME, DIALOGUE


func _ready():
	# GAME HUD LOADING
	PL_NAME.text = Globals.player_name
	PL_HP.text = str(Globals.player_hp, "/", Globals.player_max_hp)
	PL_MP.text = str(Globals.player_mp, "/", Globals.player_max_mp)
	PL_LEVEL.text = str(Globals.player_level)

func _process(_delta):
	pass
