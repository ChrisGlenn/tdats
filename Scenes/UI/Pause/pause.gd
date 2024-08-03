extends CanvasLayer
# PAUSED SCREEN
# this is the pause screen it waits for the player to press START again and then unpauses and deletes itself
func _process(_delta):
    if Input.is_action_just_pressed("td_START"):
        get_tree().paused = false # unpause the game
        queue_free() # delete self