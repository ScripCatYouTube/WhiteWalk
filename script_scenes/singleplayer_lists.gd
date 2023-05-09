extends Control

var count_worlds 
var latest_value = 0
var selected_world
var name_selected_world

func _ready():
	count_worlds = 0
	var path = "user://"
	for i in Global.get_files(path):
		var path_ = path + i + "/option.info"
		if Global.load_from_file(path_) == null:
			continue
		var data = parse_json(Global.load_from_file(path_))
		var world = load("res://ui_scenes/world_block.tscn").instance()
		var date_ = str(data["date"]["day"]) + "/" + str(data["date"]["month"]) + "/" + str(data["date"]["year"]) + "-" + str(data["date"]["hour"]) + ":" + str(data["date"]["minute"]) + ":" + str(data["date"]["second"])
		world.name_world = data["name"]
		world.position.y += count_worlds * 210
		world.date_world = date_
		world.set_name(str(count_worlds))
		$"Node2D/Control".add_child(world)
		count_worlds += 1
	$"Node2D2/VScrollBar".max_value = count_worlds * 50
	RAM.is_first_world = false
	if  count_worlds == 0:
		RAM.is_first_world = true
		get_tree().change_scene("res://ui_scenes/create_world.tscn")
func search_object(path,name):
	for i in get_node(path).get_children():
		if i.name == name:
			return i

func _process(delta):
	if $"Node2D/Control".get_children() == null:
		return
	for i in $"Node2D/Control".get_children():
		if i.is_pressed:
			if selected_world == i.name:
				if i.texture_ == i.selected_texture:
					i.texture_ = i.not_selected_texture
					i.is_pressed = false
					name_selected_world = i.name_world
					
			if selected_world != null:
				var world_block = search_object("Node2D/Control",selected_world)
				world_block.texture_ = world_block.not_selected_texture
				world_block.is_pressed = false
	
				selected_world = i.name
				i.texture_ = i.selected_texture
				i.is_pressed = true
				Global.selected_world_block = selected_world
				name_selected_world = i.name_world
				
			if selected_world == null:
				i.texture_ = i.selected_texture
				i.is_pressed = true
				selected_world = i.name
				Global.selected_world_block = i.name
				name_selected_world = i.name_world
			

func _physics_process(delta):
	if selected_world != null:
		$"Node2D2/change".disabled= false
		$"Node2D2/play".disabled = false
		$"Node2D2/delete".disabled = false
	else:
		$"Node2D2/change".disabled = true
		$"Node2D2/play".disabled = true
		$"Node2D2/delete".disabled = true		

func _on_VScrollBar_value_changed(value):
	if value == 0:
		$"Node2D".position.y = 0
	elif value < latest_value and ($"Node2D".position.y > 46):
		$"Node2D".position.y += value * 1.5
	elif value > latest_value  and ($"Node2D".position.y > (count_worlds * 52 - count_worlds * 52 - ((count_worlds * 35) * (count_worlds - 2 )))):
		$"Node2D".position.y -= value * 1.5
	latest_value = value

func _on_play_pressed():
	Global.world = search_object("Node2D/Control", selected_world).name_world
	Global.is_first_created_world = false
	get_tree().change_scene("res://scenes/map.tscn")


func _on_delete_pressed():
	RAM.is_delete_world = name_selected_world
	get_tree().change_scene("res://ui_scenes/want_to_delete.tscn")


func _on_back_pressed():
	get_tree().change_scene("res://ui_scenes/main.tscn")


func _on_create_pressed():
	get_tree().change_scene("res://ui_scenes/create_world.tscn")
