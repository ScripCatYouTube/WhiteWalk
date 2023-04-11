extends Node2D


func _ready():
	$"why".text = "WHY: " + RAM.erorr
	$"methodmath".text = "METHOD MATH: " + ROM.erorrs[RAM.erorr][0]
	$"description".text = "DESCRIPTION: " + ROM.erorrs[RAM.erorr][1] + OS.get_user_data_dir()
