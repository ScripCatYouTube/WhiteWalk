extends Camera2D


var speed = 3


func get_input():
	if Input.is_action_pressed("right"):
		self.position.x += speed
	if Input.is_action_pressed("left"):
		self.position.x -= speed
	if Input.is_action_pressed("down"):
		self.position.y += speed
	if Input.is_action_pressed("up"):
		self.position.y -= speed

func _physics_process(delta):
	get_input()

