extends KinematicBody2D

#var texture_mob = preload("res://assets/mobs/.png")
var texture_player = preload("res://assets/mobs/dude.png")
var texture_npc = preload("res://assets/mobs/ninja_red.png")
var texture_ = texture_player
var health_max = 50
var health = 50
var speed = 50
var velocity = Vector2()

func _ready():
	$"Sprite".texture = texture_
	$"TextureProgress".max_value = health_max
	
func _process(delta):
	_math_health()
	_send_ram_position_player()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right') and (position.x < RAM.cordinates_world[0]):
		velocity.x += 1
	if Input.is_action_pressed('left') and position.x > 7:
		velocity.x -= 1
	if Input.is_action_pressed('down') and position.y < (RAM.cordinates_world[1] + 32):
		velocity.y += 1
	if Input.is_action_pressed('up') and position.y > 11:
		velocity.y -= 1	
	# Make sure diagonal movement isn't faster
	velocity = velocity.normalized() * speed 
	RAM.position_player = [position.x, position.y]
	
func _physics_process(delta):
	if RAM.menu_in_game == false:
		get_input()
		velocity = move_and_slide(velocity)

func _math_health():
	$"TextureProgress".value = health
func _send_ram_position_player():
	if RAM.position_player != [position.x, position.y]:
		RAM.position_player = [position.x, position.y]
