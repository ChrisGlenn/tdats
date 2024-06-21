extends Node
# GLOBAL VARIABLES
# game variables
var game_stage : int = 0 # used to track main story progress
var current_stage : String = "Paprii City" # the current location of the player

# player variables
var player_level : int = 1 # player level
var player_hp : int = 100 # player hit points
var player_max_hp : int = 100 # maximum player hit points
var player_dmg : int = 5 # player damage
var player_def : int = 12 # player defense
var player_xp : int = 0 # player's current XP
var level_xp : Array = [0, 500, 1000, 1500, 2000, 2500, 3000] # stores the next level's xp goal
var player_inventory_weapons : Array = [0,0,0,0,0] # player's weapons
var player_inventory_armor : Array = [0,0,0,0,0] # player's armor
var player_inventory_shields : Array = [0,0,0,0,0] # player's shields
var player_inventory_items : Array = [0,0,0,0,0] # player's items