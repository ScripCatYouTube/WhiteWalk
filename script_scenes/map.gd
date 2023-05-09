extends StaticBody2D

var cordinates_player 
onready var node = get_node("map")
var sizes = [0,0]
onready var scene_menu_in_game = $Camera2D/menu

func _ready():
	var dir = Directory.new()
	var file = File.new()
	
	if file.file_exists("user://" + Global.world + "/option.info"):
		pass
	elif dir.dir_exists("user://" + Global.world + "/data"):
		pass
	else:
		RAM.erorr = ROM.erorrs["Not Found World"]
		RAM.out_erorr_screen = "res://ui_scenes/singlplayer_menu.tscn"
		get_tree().change_scene("res://ui_scenes/error_screen.tscn")
	
	
	_start()
	_spawn_player()
	var data = Global.read_world(Global.world,Global.nickname_player)
	RAM.cordinates_world = [node.cell_size.x * (sizes[0] + 1) - 9,node.cell_size.y * (sizes[1] - 4) + 12]
	_camera_player()
	scene_menu_in_game.visible = false
	#var camera = preload("res://debug_scenes/camera_debug.tscn").instance()
	#$".".add_child(camera)
	
func _start():
	
	if Global.world != null:
		var map_to_start 
		var data = Global.read_world(Global.world,Global.nickname_player)
		if data[1]:
			map_to_start = Global.read_world_map(Global.world,data[0]["cordinate_map"][0],data[0]["cordinate_map"][1],data[0]["file"])
			cordinates_player = data[0]["cordinate_player"]
		if data[1] == false:
			Global.add_player_to_map(Global.world,data[0]["file"], Global.nickname_player, Global.defualt_spawn_player["cordinate"][0], Global.defualt_spawn_player["cordinate"][1], Global.defualt_spawn_player["map"][0], Global.defualt_spawn_player["map"][1])
			_start()
			return
		sizes = [data[0]["sizex"],data[0]["sizey"]]
		RAM.position_player = data[0]["cordinate_player"]
		_load_map(map_to_start)
		
func _load_map(map):
	#"""
	var x = 0
	var y = 0
	for i in map:
		node.set_cell(x,y,i)

		if x >= Global.defualt_size_map[0]:
			x = 0
			y += 1
			continue
		x += 1
	""" 
	var tilemap = $"."  # здесь Tilemap должен быть назван "Tilemap", или измените имя переменной на имя своего Tilemap
	var tile_index = 0
	for y in range(sizes[1]):
		for x in range(sizes[0]):
			print(x," ",y," ")#,map[tile_index])
			if tile_index < len(map):
				$".".set_cell(x, y, map[tile_index])
				tile_index += 1
			else:
				break
	"""
func _spawn_player():
	#var cordinates_spawn_player = Global._title_cordinate(cordinates_player[0],cordinates_player[1], $".")
	var player_object = get_node("player")
	player_object.position = Vector2(RAM.position_player[0],RAM.position_player[1])
	
	if Global.is_first_created_world == true:
		player_object.position.x = player_object.position.x * node.cell_size.x
		player_object.position.y = player_object.position.y * node.cell_size.y
	_camera_player()
	$Camera2D.position = player_object.position
		#var data = Global.read_for_edit_world(Global.world,Global.nickname_player)

		#Global.edit_world_with_hand(Global.world,data)
	"""
	else:
		player_object.position.x = player_object.position.x
		player_object.position.y = player_object.position.y	
	"""
func _physics_process(delta):
	_camera_player()
	#settings_type
func _process(delta):
	if Input.is_action_just_pressed("to_menu"):
		if RAM.menu_in_game == false:
			scene_menu_in_game.visible = true
			RAM.menu_in_game = true
			Global.settings_type = "game"
			$Camera2D.zoom = Vector2(1,1)
		elif RAM.menu_in_game:
			$Camera2D/menu/bg.visible = false
			$Camera2D/menu/settings.visible = false
			$Camera2D/menu/conntinue.visible = true
			$Camera2D/menu/exit.visible = true
			$Camera2D/menu/options.visible = true
			Global.settings_type = "menu"
			scene_menu_in_game.visible = false
			RAM.menu_in_game = false
			RAM.in_options = false
			$Camera2D.zoom = Vector2(0.5,0.5)
		#menu_in_game.position = $player.position
	
	if Input.is_action_just_pressed("pick item and edit blocks"):
		var global_cordinate_mouse = get_global_mouse_position()
		var tilemap = node
		var tpm = tilemap.world_to_map(global_cordinate_mouse)
		var tpp = tilemap.world_to_map(Vector2(RAM.position_player[0],RAM.position_player[1]))
		var block_is_spawned
		tpm.x += 26
		tpm.y += 18

		if tpp.x - tpm.x < ROM.radios_spawn_destroy_blocks and tpp.x - tpm.x > ROM.minus_radios_spawn_destroy_blcoks and tpp.y - tpm.y < ROM.radios_spawn_destroy_blocks and tpp.y - tpm.y > ROM.minus_radios_spawn_destroy_blcoks:
			if tilemap.get_cell(tpm.x,tpm.y) == 1:
				tilemap.set_cell(tpm.x,tpm.y , 0)
				var data = Global.read_for_edit_world(Global.world,Global.nickname_player)
				var sizes = ((tpm.y * 90) + tpm.x) + (tpm.y)  #"""data["size"][0]"""
				print("map's ", tpm.x, " ", tpm.y, " gmap ", data["size"][0]," ",data["size"][1]," ",sizes)
				data["map"][sizes] = 0
				data["map"] = Global.edit_world_with_hand(Global.world,data)
					
			elif tilemap.get_cell(tpm.x,tpm.y) == 0:
				tilemap.set_cell(tpm.x,tpm.y, 1)
				var data = Global.read_for_edit_world(Global.world,Global.nickname_player)
				var max_x = data["size"][0]
				var max_y = data["size"][1]
				var sizes = ((tpm.y * 90) + tpm.x) + (tpm.y)
				print("map's ", tpm.x, " ", tpm.y, " gmap ", data["size"][0]," ",data["size"][1]," ",sizes)
				data["map"][sizes] = 1
				data["map"] = Global.edit_world_with_hand(Global.world,data)	
	
func _camera_player():
	#$Camera2D.position = $player.position
	var rect = $Camera2D.get_viewport_rect()
	var camera_pos = $Camera2D.position
	var map_cords = {"left":7,"right":RAM.cordinates_world[0],"up":11,"down":RAM.cordinates_world[1]}
	var player_pos = $player.position

	#$Camera2D.position = player_pos
	
	if (player_pos.x > (rect.size.x + map_cords["left"]) / 4 and player_pos.x < map_cords["right"] - (rect.size.x / 4)):
		camera_pos.x = player_pos.x
	if player_pos.y > (rect.size.y + map_cords["up"]) / 4 and player_pos.y < (map_cords["down"] - (rect.size.x / 6) + 67):
		camera_pos.y = player_pos.y
	$Camera2D.position = camera_pos


func _on_menu_exit_menu():
	$Camera2D.zoom = Vector2(0.5,0.5)
