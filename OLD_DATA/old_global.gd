extends Node

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
func get_map(name,x,y):
	var i_worlds = search_world(name)
	var name_world = i_worlds[1]
	var type_world = i_worlds[0]
	var path = "user://" + name_world + "/data"
	for i in get_chunks(path):
		var data_file = parse_json(load_from_file(i))
