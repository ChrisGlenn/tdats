extends Node
# CUTSCENES
# this stores the various cutscenes for the game along with a function to return the requested cutscene
# by referencing it's identifier

func set_cutscene(cutscene_id):
    match cutscene_id:
        0:
            return opening_cutscene # opening cutscene for the game
        _:
            print("ERROR: Cutscene ID: ", cutscene_id, " is not valid!")


# the cutscenes
var opening_cutscene : Dictionary = {
    # the opening cutscene for the game
    # actor 0 = player actor 1 = Renoilt
    "001" : {"mode": "spawn","path": "res://Scenes/NPCs/Renoilt/renoilt.tscn","start_x": 0,"start_y": 0,"face_dir": 2}
    #"002" : {},
    #"003" : {},
    #"004" : {},
    #"005" : {},
    #"006" : {},
    #"007" : {},
    #"008" : {},
    #"009" : {},
    #"010" : {}
}

var cutscene_template : Dictionary = {
    # cutscene template
    "001" : {},
    "002" : {},
    "003" : {},
    "004" : {},
    "005" : {},
    "006" : {},
    "007" : {},
    "008" : {},
    "009" : {},
    "010" : {}   
}