extends KinematicBody2D

var texture_mob = preload("res://assets/mobs/ninja_green.png")
var texture_player = preload("res://assets/mobs/ninja_white.png")
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
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1	
	# Make sure diagonal movement isn't faster
	velocity = velocity.normalized() * speed 
	RAM.position_player = [position.x, position.y]
	
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

func _math_health():
	$"TextureProgress".value = health
func _send_ram_position_player():
	if RAM.position_player != [position.x, position.y]:
		RAM.position_player = [position.x, position.y]
	
			
		
	
