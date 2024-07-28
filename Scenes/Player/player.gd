extends CharacterBody2D
# PLAYER SCRIPT
# player input/movement are mostly controlled here with stats, combat, ect being handled in another script
@onready var SPRITE = $AnimatedSprite2D
const TILE_SIZE : int = 16 # movement tile size
var player_animations : Array = []
var player_speed : float = 0.26 # movement speed
var player_state : String = "IDLE" # begins at 'IDLE'
var is_moving : bool = false # is moving check
var can_interact : bool = false # is true if ray is colliding w/ object or NPC
var scene_change : bool = false # if this is true then the player will stop movement and disappear after
var input_direction # movement vector
var current_collider # any interactable the player rays may be colliding with


func _ready():
	Globals.player = self # set the Global so the player can be referenced
	SPRITE.play("walkDown") # start the animation

func _physics_process(_delta):
	player_input() # player input function
	player_movement() # player movement function


func player_input():
	input_direction = Vector2.ZERO
	if Globals.can_play:
		if Input.is_action_pressed("td_UP"):
			# check the raycast collision and do a 'slide' if the player is at a corner
			if !$RayUP.is_colliding():
				input_direction = Vector2.UP # change direction to UP
				if !is_moving: player_state = "UP"
			else:
				if !is_moving: 
					SPRITE.animation = "walkUp"
					player_state = "IDLE" # stop the animation
		elif Input.is_action_pressed("td_RIGHT"):
			# check the raycast collision and do a 'slide' if the player is at a corner
			if !$RayRIGHT.is_colliding():
				input_direction = Vector2.RIGHT # change direction to RIGHT
				if !is_moving: player_state = "RIGHT"
			else:
				if !is_moving: 
					SPRITE.animation = "walkRight"
					player_state = "IDLE" # stop the animation
		elif Input.is_action_pressed("td_DOWN"):
			# check the raycast collision and do a 'slide' if the player is at a corner
			if !$RayDOWN.is_colliding():
				input_direction = Vector2.DOWN # change direction to DOWN
				if !is_moving: player_state = "DOWN"
			else:
				if !is_moving: 
					SPRITE.animation = "walkDown"
					player_state = "IDLE" # stop the animation
		elif Input.is_action_pressed("td_LEFT"):
			# check the raycast collision and do a 'slide' if the player is at a corner
			if !$RayLEFT.is_colliding():
				input_direction = Vector2.LEFT # change direction to LEFT
				if !is_moving: player_state = "LEFT"
			else:
				if !is_moving: 
					SPRITE.animation = "walkLeft"
					player_state = "IDLE" # stop the animation
		else:
			player_state = "IDLE" # set player state to IDLE
	else:
		player_state = "IDLE" # set player to idle
		input_direction = Vector2.ZERO
	# PLAYER STATES
	if player_state == "UP":
		SPRITE.play("walkUp")
	elif player_state == "RIGHT":
		SPRITE.play("walkRight")
	elif player_state == "DOWN":
		SPRITE.play("walkDown")
	elif player_state == "LEFT":
		SPRITE.play("walkLeft")
	elif player_state == "IDLE":
		pass
	# *********
	# DEBUG
	# *********
	if Input.is_action_just_pressed("td_END"):
		get_tree().quit() # quit the game

func player_movement():
	# check if input direction is valid
	if input_direction:
		# check if is_moving
		if !is_moving:
			is_moving = true # set is_moving to true
			var tween = create_tween() # create tween
			tween.tween_property(self, "position", position + input_direction*TILE_SIZE, player_speed)
			tween.tween_callback(end_movement)

func end_movement():
	if !scene_change:
		Globals.player_coords.x = global_position.x
		Globals.player_coords.y = global_position.y
		is_moving = false # reset is_moving to false
	else:
		SPRITE.visible = false # hide self
