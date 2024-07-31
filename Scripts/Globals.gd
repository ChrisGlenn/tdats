extends Node
# GLOBAL VARIABLES
# game variables
var can_play : bool = true # if the player can move or not
var game_stage : int = 0 # used to track main story progress
var current_stage : String = "~ Paprii City ~" # the current location of the player
var in_dialogue : bool = false # will be true if dialogue is happening
var in_cutscene : bool = false # will be true if cutscene is happening
var main_quest : int = -4 # tracks the main quest (the number corresponds with the array main_quests)
var side_quest : Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] # tracks the progress of the side quests

# UI variables
var game_ui # holds the UI

# player variables
var player # holds the player
var player_name : String = "Adan" # player's name
var player_class : String = "Hero" # the player's class
var player_level : int = 1 # player level
var player_hp : int = 25 # player hit points
var player_max_hp : int = 25 # maximum player hit points
var player_mp : int = 5 # player's starting mp
var player_max_mp : int = 5 # player's starting max mp
var player_xp : int = 0 # player's current XP
var player_xp_max : int = 100 # max XP to next level
var player_level_xp : Array = [0, 500, 1000, 1500, 2000, 2500, 3000] # stores the next level's xp goal
var player_level_hp : Array = []
var player_level_mp : Array = []
var player_str : int = 10 # player strength (attack strength)
var player_int : int = 10 # player intelligence (spell strength)
var player_agi : int = 10 # player agility (speed)
var player_end : int = 10 # player endurance (hardiness/defense)
var player_chr : int = 10 # player charisma (speech)
var player_lck : int = 10 # player luck (gets lucky)
var player_inventory_weapons : Array = [0,0,0,0,0,0] # player's weapons
var player_inventory_armor : Array = [0,0,0,0,0,0] # player's armor
var player_inventory_shields : Array = [0,0,0,0,0,0] # player's shields
var player_inventory_items : Array = [0,0,0,0,0,0] # player's items
var player_coords : Vector2 = Vector2(0,0)

# party variables
var party_size : int = 1 # the size of the party
# party member two (name here)
var member_two_name : String = "Jushan"
var member_two_class : String = "Archer"
var member_two_level : int = 2 # starting level
var member_two_hp : int = 25 # starting hp
var member_two_max_hp : int = 25 # starting max hp
var member_two_mp : int = 5 # starting mp
var member_two_max_mp : int = 5 # starting max mp
var member_two_level_xp : Array = []
var member_two_level_hp : Array = []
var member_two_level_mp : Array = []
var member_two_str : int = 10 # player strength (attack strength)
var member_two_int : int = 10 # player intelligence (spell strength)
var member_two_agi : int = 10 # player agility (speed)
var member_two_end : int = 10 # player endurance (hardiness/defense)
var member_two_chr : int = 10 # player charisma (speech)
var member_two_lck : int = 10 # player luck (gets lucky)
var member_two_inventory_weapons : Array = [0,0,0,0,0,0] # player's weapons
var member_two_inventory_armor : Array = [0,0,0,0,0,0] # player's armor
var pmember_two_inventory_shields : Array = [0,0,0,0,0,0] # player's shields
var member_two_inventory_items : Array = [0,0,0,0,0,0] # player's items
# party member three (name here)
var member_three_name : String = "Parus"
var member_three_class : String = "Cleric"
var member_three_level : int = 2 # starting level
var member_three_hp : int = 25 # starting hp
var member_three_max_hp : int = 25 # starting max hp
var member_three_mp : int = 5 # starting mp
var member_three_max_mp : int = 5 # starting max mp
var member_three_level_xp : Array = []
var member_three_level_hp : Array = []
var member_three_level_mp : Array = []
var member_three_str : int = 10 # player strength (attack strength)
var member_three_int : int = 10 # player intelligence (spell strength)
var member_three_agi : int = 10 # player agility (speed)
var member_three_end : int = 10 # player endurance (hardiness/defense)
var member_three_chr : int = 10 # player charisma (speech)
var member_three_lck : int = 10 # player luck (gets lucky)
var member_three_inventory_weapons : Array = [0,0,0,0,0,0] # player's weapons
var member_three_inventory_armor : Array = [0,0,0,0,0,0] # player's armor
var pmember_three_inventory_shields : Array = [0,0,0,0,0,0] # player's shields
var member_three_inventory_items : Array = [0,0,0,0,0,0] # player's items

# npc variables
var interacted : Array = [] # list of NPC's that the player has interacted with already

# combat variables
var current_enemy # the enemy the player is attacking
var current_enemy_hp : int = 0 # the HP of the current enemy for the HUD
var current_enemy_hp_max : int = 0 # the max HP of the current enemy for the HUD

# system variables
var timer_ctrl : int = 100 # timer control
var frame_timer : int = 40 # the timer between frames 0 and 1
var frame_ctrl : int = 0 # 0 to 1 for animation frames

# timer for sync purposes
func _process(delta):
    # frame timer/control
    if frame_timer > 0: frame_timer -= timer_ctrl * delta # decrement the timer
    else:
        # swap the frames
        if frame_ctrl == 0: 
            frame_ctrl = 1
            frame_timer = 40
        else: 
            frame_ctrl = 0
            frame_timer = 40

# DEBUGGING