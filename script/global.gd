extends Node

var map_name
var size_map
var world
var version_game_world
var cordinate_map

var defualt_size_map = [10,10]
var game_version = "b0.1"
var count_maps_in_chunk = 10
var defualt_spawn_player = {"map":[0,0],"cordinate":[defualt_size_map[0] / 2,defualt_size_map[1] / 2]}
var option_file = "option.info"

func _ready():
	#new_world("test")
	new_map("test",1,0)

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
func make_data(path,data,file = null):
	if file == null:
		create_file(path + "/" +  "chunk1.data")
		save_to_file(path + "/" + "chunk1.data", to_json({"map1":data,"map2":[],"map3":[],"map4":[],"map5":[],"map6":[],"map7":[],"map8":[],"map9":[],"map10":[]}))
		return	
	var data_ = parse_json(load_from_file(path + "/" + file))
	for i in range(0,10):
		if data_["map"]["map"+str(i)] == []:
			data_["map"]["map"+str(i)] = data
			save_to_file(path + "/" + file, to_json(data_))
			break
func check_file(path,file):
	var data_ = parse_json(load_from_file(path + "/" + file))
	var count = 0
	var is_count = false
	for i in range(0,10):
		if typeof(data_["map"]["map"+str(i)]) == 19:
			count = i
			is_count = true
			break
	return [is_count,count]
func create_data_void():
	var data = {"cordinate":[str(-0),str(-0)],"map":{}}
	for i in range(1,11):
		data["map"]["map" + str(i)] = []
	return data
func add_data(path,data):
	var folders = get_files(path)
	var count_len
	var text = ""
	var number
	var path_
	var data_
	var is_exit = false
	var files = []
	var to_file_write
	var last_count = 0
	var cdata = create_data_void()
	cdata["map"]["map1"] = data
	if folders == null:
		make_data(path + "/", data, null)
		return 
	for i in folders:
		path_ = path + "/" + i
		if "chunk" in i:
			count_len = len(i)
			count_len -= 1
			text = i[count_len-4] + i[count_len-3] + i[count_len-2] + i[count_len-1] + i[count_len]
			if text == ".data":
				number = ""
				for wl in i:
					if wl == "0" or wl == "1" or wl == "2" or wl == "3" or wl == "4" or wl == "5" or wl == "6" or wl == "7" or wl == "8" or wl == "9":
						number += wl
						files.append(i)
	if files == null:
		make_data(path + "/", data, null)
		return
	for i in files:
		#print(check_file(path,i)[1])
		if check_file(path,i)[0]:
			var edites_data = parse_json(load_from_file(i))
			print(edites_data)
			edites_data["map"]["map" + str(check_file(path,i)[1]+1)] = data
			save_to_file(i,to_json(edites_data))
			return
	create_file(path + "/" + "chunk" + str(len(files) + 1) + ".data")
	save_to_file(path + "/" + "chunk" + str(len(files) + 1) + ".data", to_json(cdata))
func search(element,list):
	var count = 0
	for i in list:
		if element == i:
			return count
		count += 1
	return null
func search_world(name):
	var worlds = get_worlds()
	var world 
	var is_name_folder_mode = true
	for i in worlds:
		if i == name:
			world = i
		if worlds[i] == name:
			world = worlds[i]
			is_name_folder_mode = false
			break
	return [is_name_folder_mode,world]
func get_chunks(path):
	var folders = get_files(path)
	var files = [] 
	for i in folders:
		var path_ = path + "/" + i
		if "chunk" in i:
			var count_len = len(i)
			count_len -= 1
			var text = i[count_len-4] + i[count_len-3] + i[count_len-2] + i[count_len-1] + i[count_len]
			if text == ".data":
				var number = ""
				for wl in i:
					if wl == "0" or wl == "1" or wl == "2" or wl == "3" or wl == "4" or wl == "5" or wl == "6" or wl == "7" or wl == "8" or wl == "9":
						number += wl
						files.append(i)
	return files

func new_world(name):
	var path = "user://" + name
	var path_to_data = path + "/data"
	var data = {"name":name,"game_version":game_version}
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
	var _map = {"map":[],"player":{},"entity":{"items":[],"creature":[]},"cordinate":[str(x),str(y)]}
	var block
	var choose
	var cc = 0
	var cn = 0
	var cm = 0 
	var entity
	randomize()
	for x in range(defualt_size_map[0] + 1):
		for y in range(defualt_size_map[1] + 1):
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
					print(cm, " ", count_mobs)
					continue							
	return _map
func get_map(name,x,y):
	var i_worlds = search_world(name)
	var name_world = i_worlds[1]
	var type_world = i_worlds[0]
	var path = "user://" + name_world + "/data"
	for i in get_chunks(path):
		var data_file = parse_json(load_from_file(i))
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
	print(path)
	print(folders)
	if folders == []:
		var chunk_void = make_chunk(10)
		chunk_void["map0"] = data
		create_file(path + "/" + "chunk1.data")
		save_to_file(path + "/" + "chunk1.data", to_json(chunk_void))
		return
	for i in folders:
		var data_file = parse_json(load_from_file(path + "/" + i))
		if read_maps(data_file):
			print("aboba")
			data_file[read_maps(data_file)] = data
			save_to_file(path + "/" + i, to_json(data_file))
			return
		
		
		
		
		
	

