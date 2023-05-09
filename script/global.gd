extends Node

var map_name
var size_map
var world
var version_game_world
var cordinate_map
var nickname_player
var selected_world_block
var address_server
var status_player_lists = ["no play", "multiplayer", "singleplayer"]
var status_player_in_game = ""
var settings_type
var keys = {"LEFT":"A","UP":"W","DOWN":"S","RIGHT":"D","ATTACK":"Left Mouse Button (LMB)","PICK ITEM AND EDIT BLOCKS":"Right Mouse Button (RMB)","SAY WITH PROMISER":"Middle Mouse Button (MMB)"}
#var list_keys = ["LEFT","UP","DOWN","RIGHT","ATTACK","PICK ITEM AND EDIT BLOCKS","SAY WITH PROMISER" ]
var speed_player = 2
var is_first_created_world = false

var defualt_size_map = [90,57]
var game_version = "b0.1"
var count_maps_in_chunk = 10
var defualt_spawn_player = {"map":[0,0],"cordinate":[defualt_size_map[0] / 2,defualt_size_map[1] / 2]}
var option_file = "option.info"

signal MAP_SAVE

func _ready():
	pass
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_saving()

func _saving():
	if Global.world == null:
		return
	var data
	if nickname_player == null or nickname_player == "":
		data = Global.read_for_edit_world(Global.world,"Player")
	else:
		data = Global.read_for_edit_world(Global.world,Global.nickname_player)
	data["player"][Global.nickname_player]["cordinate"] = RAM.position_player
	Global.edit_world_with_hand(Global.world,data)
	RAM.mode_saving = true
	
func _add_key(name,key):
	InputMap.add_action(name,int(key))
func _edit_key(name,key):
	if key != null:
		InputMap.erase_action(name)
		InputMap.add_action(name,int(key))
func create_file(name):
	var file = File.new()
	file.open(name, File.WRITE)
	file.store_var("")
	file.close()
func save_to_file(name,data):
	var file = File.new()
	file.open(name, File.WRITE)
	file.store_var(data)
	file.close()
func load_from_file(name):
	var file = File.new()
	var data
	if file.file_exists(name):
		file.open(name, File.READ)
		data = file.get_var()
		file.close()
	return data

func delete_world(world):
	var dir = Directory.new()
	var file = File.new()
	var path = "user://" + world

	if file.file_exists(path + "/" + "option.info"):
		dir.remove(path + "/" + "option.info")
	if dir.dir_exists(path + "/" + "data"):
		for i in get_files(path + "/" + "data"):
			dir.remove(path + "/" + "data/" + i)
		dir.remove(path + "/" + "data")
	dir.remove(path)
	
func get_files(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true)

	var file = dir.get_next()
	while file != '':
		files += [file]
		file = dir.get_next()

	return files
func make_dir(folder,path="user://"):
	var dir = Directory.new()
	dir.open(path)
	dir.make_dir(folder)
func get_worlds():
	var path = "user://"
	var path_to_world
	var to_option_file
	var data
	var text
	var folders = get_files("user://")
	var names = {}
	if folders != null:
		for i in folders:
			path_to_world = path + i + "/"
			to_option_file = path_to_world + option_file
			text = load_from_file(to_option_file)
			if text != null:
				data = parse_json(text)
				names[i] = data["name"]
	return names

func new_world(name):
	var path = "user://" + name
	var path_to_data = path + "/data"
	var data = {"name":name, "game_version":game_version, "date":{"year":OS.get_date()["year"], "month":OS.get_date()["month"], "day":OS.get_date()["day"], "hour":OS.get_time().hour, "minute":OS.get_time().minute, "second":OS.get_time().second}}
	make_dir(path)
	create_file(path + "/" + option_file)
	save_to_file(path + "/" + option_file, to_json(data))
	make_dir(path_to_data)
	new_map(name,0,0)
func new_map(name_world,x,y):
	add_map_new("user://" + name_world + "/data",generation_map(x,y))
func generation_map(x,y):
	var count_cristals = Settings.cristals()
	var count_npcs = Settings.npcs()
	var count_mobs = Settings.mobs()
	var _map = {"map":[],"player":{},"entity":{"items":[],"creature":[]},"cordinate":[str(x),str(y)],"size":[defualt_size_map[0], defualt_size_map[1]]}
	var block
	var choose
	var cc = 0
	var cn = 0
	var cm = 0 
	var entity
	randomize()
	for x in range(defualt_size_map[0] - 1):
		for y in range(defualt_size_map[1] - 1):
			block = Settings.block()
			_map["map"] += [Settings.block()]
			if block == 0:
				entity = Settings.rand(0,2)	
				choose = [Settings.chance(),Settings.chance(),Settings.chance(),Settings.chance(),Settings.chance(),]
				if [choose[0] == true or choose[2] == true and choose[4] == true] and cc < count_cristals:
					_map["entity"]["items"] += [{"type":"cristal","name":"cristal","cordinate":[str(x * 32), str(y * 32)]}]
					cc += 1
					continue
				if [choose[1] == false or choose[3] == true] and cn < count_npcs:
					_map["entity"]["creature"].append({"type":"npc","name":"npc","cordinate":[str(x * 32), str(y * 32)]})
					cn += 1
					continue
				if [entity == 1] and [choose[0] == false and choose[3] == true and choose[4] == true and choose[2] == false] and cm < count_mobs:
					_map["entity"]["creature"].append({"type":"mob","name":"mob","cordinate":[str(x * 32), str(y * 32)]})
					cm += 1
					continue							
	return _map
func make_chunk(count):
	var chunk = {}
	for i in range(0,count):
		chunk["map"+str(i)] = "null"
	return chunk
func read_maps(data):
	for i in data:
		if typeof(data[i]) == TYPE_STRING:
			return i
	return false
func add_map_new(path,data):
	var folders = get_files(path)
	
	if folders == []:
		var chunk_void = make_chunk(10)
		chunk_void["map0"] = data
		create_file(path + "/" + "chunk1.data")
		save_to_file(path + "/" + "chunk1.data", to_json(chunk_void))
		return
	for i in folders:
		var data_file = parse_json(load_from_file(path + "/" + i))
		if read_maps(data_file):
			data_file[read_maps(data_file)] = data
			save_to_file(path + "/" + i, to_json(data_file))
			return
	var chunk_void = make_chunk(10)
	chunk_void["map0"] = data
	create_file(path + "/" + "chunk" + str(len(folders)+1) + ".data")
	save_to_file(path + "/" + "chunk" + str(len(folders)+1) + ".data", to_json(chunk_void))
func read_world_map(name,x,y,file):
	var path = "user://" + name + "/data/" + file
	var data_chunk = parse_json(load_from_file(path))
	for i in data_chunk:
		if data_chunk[i]["cordinate"][0] == x and data_chunk[i]["cordinate"][1] == y:
			return data_chunk[i]["map"]
func read_world(name,player):
	var path = "user://" + name
	for file in get_files(path + "/data"):
		var data_chunk = parse_json(load_from_file(path + "/data/" + file))
		for i in data_chunk:
			var d_ch = data_chunk[i]
			if typeof(d_ch) == TYPE_DICTIONARY:
				if player in data_chunk[i]["player"]:
					return [{"cordinate_map":data_chunk[i]["cordinate"], "cordinate_player":[data_chunk[i]["player"][player]["cordinate"][0],data_chunk[i]["player"][player]["cordinate"][1]],"sizex":data_chunk[i]["size"][0],"sizey":data_chunk[i]["size"][1],"file":file}, true]
	return [{"cordinate_map":[defualt_size_map[0],defualt_size_map[1]], "cordinate_player":defualt_spawn_player["cordinate"],"file":"chunk1.data"}, false]
func read_world_map_cordinate(name,x,y):
	var path = "user://" + name
	for i in get_files(path + "/data"):
		var data_chunk = parse_json(load_from_file(path + "/data/" + i))
		for map in data_chunk:
			if typeof(data_chunk[map]) == TYPE_DICTIONARY:
				if int(data_chunk[map]["cordinate"][0]) == x and int(data_chunk[map]["cordinate"][1]) == y:
					return data_chunk[map]["map"]
	return "1"
func read_world_cordinate(name,x,y):
	var path = "user://" + name
	for i in get_files(path + "/data"):
		var data_chunk = parse_json(load_from_file(path + "/data/" + i))
		
			
func add_player_to_map(name,file,name_player,x,y,x_map,y_map):
	var path = "user://" + name + "/data/" + file
	var data = parse_json(load_from_file(path))
	for i in data:
		if int(data[i]["cordinate"][0]) == x_map and int(data[i]["cordinate"][1]) == y_map:
			data[i]["player"][name_player] = {"cordinate":[x,y],"inventory":{"hand":{"1":[],"2":[]},"backpack":{"1":[],"2":[],"3":[],"4":[],"5":[],"6":[]}}}
			save_to_file(path,to_json(data))
			return
func _title_cordinate(x,y,tilemap):
	var tile_size = tilemap.cell_size
	var tile_origin = tilemap.cell_tile_origin
	var tile_x = int((x - tile_origin) / tile_size.x)
	var tile_y = int((y - tile_origin) / tile_size.y)

	# Получение координат центра тайла
	var tile_center_x = tile_origin + tile_x * tile_size.x + tile_size.x / 2
	var tile_center_y = tile_origin + tile_y * tile_size.y + tile_size.y / 2
	tile_center_x *= tile_size
	tile_center_y *= tile_size
	return [tile_center_x[0], tile_center_y[0]]

func read_for_edit_world(name,player):
	var path = "user://" + name
	for i in get_files(path + "/data"):
		var data_chunk = parse_json(load_from_file(path + "/data/" + i))
		for map in data_chunk:
			if typeof(data_chunk[map]) == TYPE_DICTIONARY:
				if Global.nickname_player in data_chunk[map]["player"]:
					return data_chunk[map]			
func edit_world_with_hand(name,data):
	var path = "user://" + name
	for i in get_files(path + "/data"):
		var data_chunk = parse_json(load_from_file(path + "/data/" + i))
		for map in data_chunk:
			if typeof(data_chunk[map]) == TYPE_DICTIONARY:
				if int(data_chunk[map]["cordinate"][0]) == RAM.cordinate_map[0] and int(data_chunk[map]["cordinate"][1]) == int(RAM.cordinate_map[1]):
					data_chunk[map] = data
					save_to_file(path + "/data/" + i, to_json(data_chunk))

func get_all_blocks_in_array_TileMap(node,size_x,size_y):
	var output_array = []
	var x = 0
	var y = 0
	var res = size_x * size_y
	for i in range(res):
		if node.get_cell(x,y) != -1:
			output_array.append(node.get_cell(x,y))
		#print(x," ",y, " ",node.get_cell(x,y))
		
		if x > size_x:
			y += 1
			x = 0
		x += 1
	return output_array
	"""
	var tilemap = node
	var tile_list = []

	for x in range(tilemap.get_used_rect().size.x):
		for y in range(tilemap.get_used_rect().size.y):
			var tile_id = tilemap.get_cell(x, y)
			if tile_id != -1:
				tile_list.append(tile_id)
	return tile_list
	"""	

func oldcords_to_tilecords():
	pass
