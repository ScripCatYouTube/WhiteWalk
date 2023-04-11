extends Node2D

func _ready():
	$"Label".text = "YOU WANT DELETE THE WORLD \nNAME WORLD: " + RAM.is_delete_world

func _on_yes_pressed():
	Global.delete_world(RAM.is_delete_world )
	get_tree().change_scene("res://ui_scenes/singlplayer_menu.tscn")

func _on_no_pressed():
	get_tree().change_scene("res://ui_scenes/singlplayer_menu.tscn")
