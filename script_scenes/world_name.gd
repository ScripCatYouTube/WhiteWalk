extends Node2D


var input_text = "New World"
func _ready():
	$"1".text = input_text

func _on_LineEdit_text_changed(new_text):
	input_text = new_text
	$"1".text = input_text

func _on_create_pressed():
	if input_text != "":
		Global.new_world(input_text)
		Global.world = input_text
		Global.cordinate_map = Global.defualt_spawn_player["map"]
		get_tree().change_scene("res://scenes/map.tscn")
