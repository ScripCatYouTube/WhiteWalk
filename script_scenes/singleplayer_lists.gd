extends Node2D

var count_worlds 
var latest_value = 0

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
		print(data["name"])
		world.name_world = data["name"]
		world.position.y += count_worlds * 210
		world.date_world = date_
		world.set_name(str(count_worlds))
		$"Node2D/Control".add_child(world)
		count_worlds += 1
	$"VScrollBar".max_value = count_worlds * 50
	print((count_worlds * 52 - count_worlds * 52 - count_worlds * 52))

func _process(delta):
	if $"Node2D/Control".get_children() == null:
		return
	for i in $"Node2D/Control".get_children():
		if i.is_pressed == true:
			Global.world = i.name_world
			get_tree().change_scene("res://scenes/map.tscn")
			return

func _on_VScrollBar_value_changed(value):
	print($"Node2D".position.y)
	#var value = $"VScrollBar".value
	if value == 0:
		$"Node2D".position.y = 0
	#if $"Node2D".position.y < count_worlds * 52 - count_worlds * 52 - count_worlds * 45:
	#	$"Node2D".position.y = count_worlds * 52 - count_worlds * 52 - count_worlds * 10

	elif value > latest_value  and ($"Node2D".position.y > (count_worlds * 52 - count_worlds * 52 - count_worlds * 35)):
		$"Node2D".position.y -= value * 1.5

	elif value < latest_value and ($"Node2D".position.y > 46):
		$"Node2D".position.y += value * 1.5
	latest_value = value

