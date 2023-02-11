extends Control

var settings_file = "settings.info"
var defualt_nickname_player = "MushroomPLayer123"
var text = ""

func _ready():
	var file = File.new()
	if file.file_exists("user://OPTIONS/" + settings_file):
		var data_file = Global.load_from_file("user://OPTIONS/" + settings_file)
		Global.nickname_player = data_file
		$status.add_color_override("font_color", Color(0,1,0))
		$status.text = "You can enter the game with this nickname"
	else:
		Global.make_dir("user://OPTIONS")
		Global.create_file("user://OPTIONS/" + settings_file)
		Global.save_to_file("user://OPTIONS/" + settings_file, defualt_nickname_player)
		Global.nickname_player = defualt_nickname_player
		$status.add_color_override("font_color", Color(0,1,0))
		$status.text = "You can enter the game with this nickname"
	$input_nickname.text = Global.nickname_player	
	$input_text.add_color_override("font_color", Color(1,0.7529,0.7961))
		
func _process(delta):
	if $input_nickname.text != "":
		Global.nickname_player = $input_nickname.text
		Global.save_to_file("user://OPTIONS/" + settings_file, Global.nickname_player)
		$input_text.text = "INPUT NICKNAME: " + Global.nickname_player
		$status.add_color_override("font_color", Color(0,1,0,1))
		$status.text = "You can enter the game with this nickname"
	else:
		$status.add_color_override("font_color", Color(1,0,0,1))
		$status.text = "You cannot enter the game with this nickname"
