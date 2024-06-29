extends CharacterBody2D
# PLAYER SCRIPT
# player input/movement are mostly controlled here with stats, combat, ect being handled in another script
@onready var SPRITE = $AnimatedSprite2D
const TILE_SIZE : int = 16 # movement tile size
var player_speed : float = 0.26 # movement speed
var player_state : String = "IDLE" # begins at 'IDLE'
var is_moving : bool = false # is moving check
var can_interact : bool = false # is true if ray is colliding w/ object or NPC
var input_direction # movement vector
var current_collider # any interactable the player rays may be colliding with


func _ready():
    pass

func _physics_process(_delta):
    player_input() # player input function
    player_movement() # player movement function


func player_input():
    input_direction = Vector2.ZERO
    if Input.is_action_pressed("td_UP"):
        # check the raycast collision and do a 'slide' if the player is at a corner
        if !$RayUP.is_colliding():
            $AnimatedSprite2D.play("walkUp") # start walk animation
            input_direction = Vector2.UP # change direction to UP
    elif Input.is_action_pressed("td_RIGHT"):
        # check the raycast collision and do a 'slide' if the player is at a corner
        if !$RayRIGHT.is_colliding():
            $AnimatedSprite2D.play("walkRight") # start walk animation
            input_direction = Vector2.RIGHT # change direction to RIGHT
    elif Input.is_action_pressed("td_DOWN"):
        # check the raycast collision and do a 'slide' if the player is at a corner
        if !$RayDOWN.is_colliding():
            $AnimatedSprite2D.play("walkDown") # start walk animation
            input_direction = Vector2.DOWN # change direction to DOWN
    elif Input.is_action_pressed("td_LEFT"):
        # check the raycast collision and do a 'slide' if the player is at a corner
        if !$RayLEFT.is_colliding():
            $AnimatedSprite2D.play("walkLeft") # start walk animation
            input_direction = Vector2.LEFT # change direction to LEFT
    else:
        player_state = "IDLE" # set player state to IDLE
        $AnimatedSprite2D.stop() # stop the animation
    # check for interactable collisions (they will be in the group INTERACT)
    if $RayUP.is_colliding():
        current_collider = $RayUP.get_collider()
        if current_collider.is_in_group("INTERACT"):
            current_collider.is_active = true
    else:
        if current_collider:
            if current_collider.is_in_group("INTERACT"): 
                current_collider.is_active = false
                current_collider = null
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
    is_moving = false # reset is_moving to false
