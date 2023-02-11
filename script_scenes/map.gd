extends TileMap

func _ready():
	_start()
func _start():
	if Global.world != null:
		var map_to_start 
		var data = Global.read_world(Global.world,Global.nickname_player)
		if data[1]:
			map_to_start = Global.read_world_map(Global.world,data[0]["cordinate_map"][0],data[0]["cordinate_map"][1],data[0]["file"])
		if data[1] == false:
			print(data[1])
			Global.add_player_to_map(Global.world,data[0]["file"], Global.nickname_player, Global.defualt_spawn_player["cordinate"][0], Global.defualt_spawn_player["cordinate"][1], Global.defualt_spawn_player["map"][0], Global.defualt_spawn_player["map"][1])
			_start()
			return
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
