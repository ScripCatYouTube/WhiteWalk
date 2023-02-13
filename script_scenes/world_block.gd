extends Node2D

var name_world = ""
var date_world = "" 
var is_pressed = false
var not_selected_texture = preload("res://assets/ui/world_block.png")
var selected_texture = preload("res://assets/ui/world_block_selected.png")
var texture_ = not_selected_texture

onready var sprite = get_node("WorldBlock")

func _ready():
	#sprite.set_texture(not_selected_texture)
	$"name".text = name_world
	$"date".text = date_world

func _on_Button_pressed():
	if is_pressed == false:
		is_pressed = true
	elif is_pressed == true:
		is_pressed = false

func _process(delta):

	sprite.set_texture(texture_)
