extends KinematicBody2D
# VARIABLES GO HERE
onready var ANIM = $AnimatedSprite
var creator # used for cutscenes
var stationary = true # not needed for CSKida
var cutscene = true # not needed for CSKida
var walk_speed = 32 # movement speed
var start_dir = 0 # 0 is up, right, down, left (default is 2 'down')
var moving = false # if the NPC is moving or not
var move_dir = 0 # 0 is up 1 is right 2 is down 3 is left (movement direction)
var coord = 0 # the coord to move to
var stopped = false # if the player gets close the NPC will stop walking


# SYSTEM FUNCTIONS
func _ready():
	# set starting direction
	if start_dir == 0: 
		ANIM.play("walkUp")
		ANIM.frame = 1
	elif start_dir == 1:
		ANIM.play("walkRight")
		ANIM.frame = 1
	elif start_dir == 2:
		ANIM.play("walkDown")
		ANIM.frame = 1
	else:
		ANIM.play("walkLeft")
		ANIM.frame = 1

func _physics_process(delta):
	movement(delta) # movement function


# CUSTOM FUNCTIONS
func movement(clock):
	# cutscene movement
	if moving and !stopped:
		if move_dir == 0:
			# walk up
			ANIM.play("walkUp")
			if coord < global_position.y:
				if !stopped:
					position.y -= walk_speed * clock
			else:
				global_position.y = coord
				if cutscene: creator.inc_cutscene()
				moving = false
		elif move_dir == 1:
			# walk right
			ANIM.play("walkRight")
			if coord > global_position.x:
				if !stopped:
					position.x += walk_speed * clock
			else:
				global_position.x = coord
				if cutscene: creator.inc_cutscene()
				moving = false
		elif move_dir == 2:
			# walk down
			ANIM.play("walkDown")
			if coord > global_position.y:
				if !stopped:
					position.y += walk_speed * clock
			else:
				global_position.y = coord
				if cutscene: creator.inc_cutscene()
				moving = false
		elif move_dir == 3:
			# walk left
			ANIM.play("walkLeft")
			if coord < global_position.x:
				if !stopped:
					position.x -= walk_speed * clock
			else:
				global_position.x = coord
				if cutscene: creator.inc_cutscene()
				moving = false
	else:
		# stop CSKida
		ANIM.frame = 1 # set the frame to idle
		ANIM.stop() # stop the animation


# SIGNAL FUNCTIONS
