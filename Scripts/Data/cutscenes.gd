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
    # actor 0 = Renoilt
    "001" : {"mode": "spawn","path": "res://Scenes/NPCs/Renoilt/renoilt.tscn","start_x": 112,"start_y": 32,"face_dir": 2},
    "002" : {"mode": "timer","amount": 300},
    "003" : {"mode": "npc","actor": 0,"face_dir": 2,"move_to": Vector2(0,64)},
    "004" : {"mode": "npc","actor": 0,"face_dir": 3,"move_to": Vector2(80,0)},
    "005" : {"mode": "dialogue","name": "RENOILT:","dialogue": "I can't believe it. You are awake!","close": false},
    "006" : {"mode": "dialogue","name": "RENOILT:","dialogue": "I apologize, I was sure you weren't going to make it.","close": false},
    "007" : {"mode": "dialogue","name": "RENOILT:","dialogue": "My name is Renoilt. I found you \noutside the city gates...","close": false},
    "008" : {"mode": "dialogue","name": "RENOILT:","dialogue": "...you had been attacked and close \nto death.","close": false},
    "009" : {"mode": "dialogue","name": Globals.player_name.to_upper() + ":","dialogue": "...I...don't remember...","close": false},
    "010" : {"mode": "dialogue","name": "RENOILT:","dialogue": "Your memory will return to you, I'm sure.","close": false},
    "011" : {"mode": "dialogue","name": "RENOILT:","dialogue": "I have bad news, though. While you were out...","close": false},
    "012" : {"mode": "dialogue","name": "RENOILT:","dialogue": "a large tower, like a sword, fell from the sky...","close": false},
    "013" : {"mode": "dialogue","name": "RENOILT:","dialogue": "and pierced the city. Now the creatures from inside...","close": false},
    "014" : {"mode": "dialogue","name": "RENOILT:","dialogue": "have taken control of the city. You look like a capable fighter.","close": false},
    "015" : {"mode": "dialogue","name": "RENOILT:","dialogue": "Please go to the Temple and see Elom, the Priest.","close": false},
    "016" : {"mode": "dialogue","name": "RENOILT:","dialogue": "He will let you know how you can help.","close": true},
    "017" : {"mode": "npc","actor": 0,"face_dir": 1,"move_to": Vector2(112,0)},
    "018" : {"mode": "npc","actor": 0,"face_dir": 0,"move_to": Vector2(0,32)},
    "019" : {"mode": "npc","actor": 0,"face_dir": 2,"move_to": Vector2(112,32)},
    "020" : {"mode": "main_quest","quest": 1},
    "021" : {"mode": "game_stage","stage": 1},
    "022" : {"mode": "fin"}
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