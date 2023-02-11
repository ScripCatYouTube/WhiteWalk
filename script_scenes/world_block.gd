extends Node2D

var name_world = ""
var date_world = "" 
var is_pressed = false

func _ready():
	$"name".text = name_world
	$"date".text = date_world

func _on_Button_pressed():
	is_pressed = true
