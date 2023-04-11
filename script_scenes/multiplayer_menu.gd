extends Node2D

func _ready():
	pass # Replace with function body.

func _on_back_pressed():
	get_tree().change_scene("res://ui_scenes/main.tscn")
