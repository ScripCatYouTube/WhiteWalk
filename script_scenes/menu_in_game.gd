extends Node2D


func _on_conntinue_pressed():
	get_tree().change_scene("res://scenes/map.tscn")

func _on_exit_pressed():
	Global._saving()
	get_tree().change_scene("res://ui_scenes/main.tscn")
func _on_options_pressed():
	Global.settings_type = "game"
	get_tree().change_scene("res://scenes/settings.tscn")

