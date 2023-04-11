extends TileMap

var cordinates_player 

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
		RAM.position_player = data[0]["cordinate_player"]
		_load_map(map_to_start)
func _load_map(map):
	var x = 0
	var y = 0
	for i in map:
		$".".set_cell(x,y,i)
		x += 1
		if x-1 > Global.defualt_size_map[0]:
			x = 0
			y += 1 
func _spawn_player():
	var cordinates_spawn_player = Global._title_cordinate(cordinates_player[0],cordinates_player[1], $".")
	var player_object = preload("res://objects/player.tscn").instance()
	player_object.position = Vector2(cordinates_player[0],cordinates_player[1])
	get_node(".").add_child(player_object)
	print(get_node(".").get_cell(1000,1000))
	if Global.is_first_created_world == true:
		player_object.position.x = player_object.position.x * $".".cell_size.x
		player_object.position.y = player_object.position.y * $".".cell_size.y
		var data = Global.read_for_edit_world(Global.world,Global.nickname_player)

		Global.edit_world_with_hand(Global.world,data)
	else:
		player_object.position.x = player_object.position.x
		player_object.position.y = player_object.position.y	
		
func _process(delta):
	if Input.is_action_pressed("to_menu"):
		get_tree().change_scene("res://scenes/menu_in_game.tscn")
	
	if Input.is_action_just_pressed("pick item and edit blocks"):
		var global_cordinate_mouse = get_global_mouse_position()
		var tilemap = $"."
		var tpm = tilemap.world_to_map(global_cordinate_mouse)
		var tpp = tilemap.world_to_map(Vector2(RAM.position_player[0],RAM.position_player[1]))
		var block_is_spawned
		tpm.x += 26
		tpm.y += 18

		if tpp.x - tpm.x < ROM.radios_spawn_destroy_blocks and tpp.x - tpm.x > ROM.minus_radios_spawn_destroy_blcoks and tpp.y - tpm.y < ROM.radios_spawn_destroy_blocks and tpp.y - tpm.y > ROM.minus_radios_spawn_destroy_blcoks:
			if tilemap.get_cell(tpm.x,tpm.y) == 1:
				tilemap.set_cell(tpm.x,tpm.y , 0)
					
			elif tilemap.get_cell(tpm.x,tpm.y) == 0:
				tilemap.set_cell(tpm.x,tpm.y, 1)
	







