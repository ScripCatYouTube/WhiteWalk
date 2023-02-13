extends Node2D

func _ready():
	Global.settings_type = "game"

func _on_conntinue_pressed():
	get_tree().change_scene("res://scenes/map.tscn")

func _on_exit_pressed():
	get_tree().change_scene("res://ui_scenes/main.tscn")
func _on_options_pressed():
	#get_tree().change_scene("res://ui_scenes/main.tscn")
	pass
