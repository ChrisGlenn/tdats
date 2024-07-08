extends Node
# GLOBAL VARIABLES
# game variables
var game_stage : int = 0 # used to track main story progress
var current_stage : String = "Paprii City" # the current location of the player

# player variables
var player_name : String = "Adan" # player's name
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
# party member (name here)
var member_one_name : String = ""

# npc variables
var interacted : Array = [] # list of NPC's that the player has interacted with already

# combat variables
var current_enemy # the enemy the player is attacking
var current_enemy_hp : int = 0 # the HP of the current enemy for the HUD
var current_enemy_hp_max : int = 0 # the max HP of the current enemy for the HUD

# system variables
var timer_ctrl : int = 100 # timer control
