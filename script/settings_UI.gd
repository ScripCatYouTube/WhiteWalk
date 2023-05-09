extends Control

signal exito

func _on_back_pressed():
	print("Type settings type: ",Global.settings_type)
	if Global.settings_type == "game":
		RAM.in_options = false
		RAM.exit_out_option = true
	elif Global.settings_type == "menu":
		get_tree().change_scene("res://ui_scenes/main.tscn")
	#else:
	#	get_tree().change_scene("res://ui_scenes/main.tscn")
