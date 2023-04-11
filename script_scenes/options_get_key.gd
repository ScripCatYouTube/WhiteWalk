extends Control

export var index_key_option = "left"
export var name_key_option = "Left"
var is_pressed_button = false

func _ready():
	
	$"Key".text = name_key_option
	$"NameButton".text = index_key_option

func _on_Button_pressed():
	is_pressed_button  = true
	$"Key".text = ""

func _input(event):
	if is_pressed_button  == false:
		return
	var name_button
	var is_mouse 
	var scancode
	var button
	if event is InputEventKey and event.is_pressed():
		is_mouse = false
		name_button = event.as_text()
		scancode = event.scancode
		#print(button, " ", name_button)
	elif event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			name_button = "BUTTON_LEFT"
		if event.button_index == BUTTON_RIGHT:
			name_button = "BUTTON_RIGHT"
		if event.button_index == BUTTON_MIDDLE:
			name_button = "BUTTON_MIDDLE"
		if event.button_index == BUTTON_WHEEL_DOWN:
			name_button = "BUTTON_WHEEL_DOWN"
		if event.button_index == BUTTON_WHEEL_UP:
			name_button = "BUTTON_WHEEL_UP"
		if event.button_index == BUTTON_WHEEL_LEFT:
			name_button = "BUTTON_WHEEL_LEFT"
		if event.button_index == BUTTON_WHEEL_RIGHT:
			name_button = "BUTTON_WHEEL_RIGHT"
		is_mouse = true
	if is_mouse != null:
		if is_mouse == false:
			Global._edit_key(index_key_option.to_lower(),scancode)
			Global.keys[index_key_option] = name_button
			$"Key".text = name_button
		elif is_mouse == true:
			Global._edit_key(index_key_option.to_lower(),scancode)
			Global.keys[index_key_option] = name_button
			if event.button_index == 1:
				$"Key".text = "Left Mouse Button (LMB)"
			elif event.button_index == 2:
				$"Key".text = "Right Mouse Button (RMB)"
			if event.button_index == 3:
				$"Key".text = "Middle Mouse Button (MMB)"
		is_pressed_button = false
