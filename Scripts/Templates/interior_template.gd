extends Node
# INTERIOR SCENE TEMPLATE
@export var stage_name : String = "DEFAULT" # what the HUD will display (Globals.current_stage)


func _ready():
    Globals.current_stage = stage_name