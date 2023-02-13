extends Node2D

var count_worlds 
var latest_value = 0
var selected_world

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
	$"VScrollBar".max_value = count_worlds * 50

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
			if selected_world != null:
				var world_block = search_object("Node2D/Control",selected_world)
				world_block.texture_ = world_block.not_selected_texture
				world_block.is_pressed = false
	
				selected_world = i.name
				i.texture_ = i.selected_texture
				i.is_pressed = true
				Global.selected_world_block = selected_world

			if selected_world == null:
				i.texture_ = i.selected_texture
				i.is_pressed = true
				selected_world = i.name
				Global.selected_world_block = i.name
			

func _physics_process(delta):
	if selected_world != null:
		$"change".disabled= false
		$"play".disabled = false
		$"delete".disabled = false
	else:
		$"change".disabled = true
		$"play".disabled = true
		$"delete".disabled = true		

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
	get_tree().change_scene("res://scenes/map.tscn")
