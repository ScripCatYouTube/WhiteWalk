extends Control


func _on_back_pressed():
	if Global.settings_type == "game":
		get_tree().change_scene("res://scenes/menu_in_game.tscn")
	elif Global.settings_type == "menu":
		get_tree().change_scene("res://ui_scenes/main.tscn")
	else:
		get_tree().change_scene("res://ui_scenes/main.tscn")
