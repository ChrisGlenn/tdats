extends Node
# GLOBAL VARIABLES
# game variables
var game_stage : int = 0 # used to track main story progress
var current_stage : String = "Paprii City" # the current location of the player

# player variables
var player_level : int = 1 # player level
var player_hp : int = 100 # player hit points
var player_max_hp : int = 100 # maximum player hit points
var player_xp : int = 0 # player's current XP
var player_xp_max : int = 100
var player_level_xp : Array = [0, 500, 1000, 1500, 2000, 2500, 3000] # stores the next level's xp goal
var player_inventory_weapons : Array = [0,0,0,0,0,0] # player's weapons
var player_inventory_armor : Array = [0,0,0,0,0,0] # player's armor
var player_inventory_shields : Array = [0,0,0,0,0,0] # player's shields
var player_inventory_items : Array = [0,0,0,0,0,0] # player's items

# party variables
var party_size : int = 1 # the size of the current party (this is subject to change)

# combat variables
var current_enemy # the enemy the player is attacking
var current_enemy_hp : int = 0 # the HP of the current enemy for the HUD
var current_enemy_hp_max : int = 0 # the max HP of the current enemy for the HUD