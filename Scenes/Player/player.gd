extends CharacterBody2D
# PLAYER SCRIPT
# player input/movement are mostly controlled here with stats, combat, ect being handled in another script
@onready var SPRITE = $AnimatedSprite2D
const TILE_SIZE : int = 8 # movement tile size
var player_speed : float = 0.13 # movement speed
var player_state : String = "IDLE" # begins at 'IDLE'
var is_moving : bool = false # is moving check
var input_direction # movement vector


func _ready():
    pass

func _physics_process(_delta):
    player_input() # player input function
    player_movement() # player movement function


func player_input():
    input_direction = Vector2.ZERO
    if Input.is_action_pressed("td_UP"):
        # check the raycast collision and do a 'slide' if the player is at a corner
        if !$RayUL.is_colliding() and !$RayUR.is_colliding():
            input_direction = Vector2.UP # change direction to UP
        elif $RayUL.is_colliding() and !$RayUR.is_colliding():
            input_direction = Vector2.RIGHT # slide to the RIGHT
        elif !$RayUL.is_colliding() and $RayUR.is_colliding():
            input_direction = Vector2.LEFT # slide to the LEFT
    elif Input.is_action_pressed("td_RIGHT"):
        # check the raycast collision and do a 'slide' if the player is at a corner
        if !$RayRU.is_colliding() and !$RayRL.is_colliding():
            input_direction = Vector2.RIGHT # change direction to RIGHT
        elif $RayRU.is_colliding() and !$RayRL.is_colliding():
            input_direction = Vector2.DOWN # slide DOWN
        elif !$RayRU.is_colliding() and $RayRL.is_colliding():
            input_direction = Vector2.UP # slide UP
    elif Input.is_action_pressed("td_DOWN"):
        # check the raycast collision and do a 'slide' if the player is at a corner
        if !$RayDL.is_colliding() and !$RayDR.is_colliding():
            input_direction = Vector2.DOWN # change direction to DOWN
        elif $RayDL.is_colliding() and !$RayDR.is_colliding():
            input_direction = Vector2.RIGHT # slide to the RIGHT
        elif !$RayDL.is_colliding() and $RayDR.is_colliding():
            input_direction = Vector2.LEFT # slide to the LEFT
    elif Input.is_action_pressed("td_LEFT"):
        # check the raycast collision and do a 'slide' if the player is at a corner
        if !$RayLU.is_colliding() and !$RayLL.is_colliding():
            input_direction = Vector2.LEFT # change direction to LEFT
        elif $RayLU.is_colliding() and !$RayLL.is_colliding():
            input_direction = Vector2.DOWN # slide DOWN
        elif !$RayLU.is_colliding() and $RayLL.is_colliding():
            input_direction = Vector2.UP # slide UP
    else:
        player_state = "IDLE" # set player state to IDLE
    # DEBUG
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
