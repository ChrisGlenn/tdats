extends Node
# INTERIOR SCENE TEMPLATE
@export var stage_name : String = "DEFAULT" # what the HUD will display (Globals.current_stage)
var check : bool = false # used as a check


func _ready():
    Globals.current_stage = stage_name

func _process(_delta):
    pass


func clear_characters():
    for n in $Characters.get_children():
        $Characters.remove_child(n) # remove the child