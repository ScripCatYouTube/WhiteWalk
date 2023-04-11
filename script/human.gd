extends KinematicBody2D

var texture_mob = preload("res://assets/mobs/ninja_green.png")
var texture_player = preload("res://assets/mobs/ninja_white.png")
var texture_npc = preload("res://assets/mobs/ninja_red.png")
var texture_
var health_max = 50
var health = 50

func _ready():
	$"Sprite".texture = texture_
	$"TextureProgress".max_value = health_max
	

func _process(delta):
	_math_health()

func _math_health():
	$"TextureProgress".value = health
