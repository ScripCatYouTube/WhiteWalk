extends Node2D

var texture_mob = preload("res://textures/mobs/ninja_green.png")
var texture_player = preload("res://textures/mobs/ninja_white.png")
var texture_npc = preload("res://textures/mobs/ninja_red.png")
var texture_ = texture_player

func _ready():
	$"Sprite".texture = texture_
