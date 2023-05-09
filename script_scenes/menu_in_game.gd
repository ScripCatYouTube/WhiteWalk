extends Control

signal exit_menu

func _ready():
	$bg.visible = false
	$settings.visible = false
	$conntinue.visible = true
	$exit.visible = true
	$options.visible = true
	Global.settings_type == "menu"
	RAM.in_options = false	
	RAM.exit_out_option = false
	$White.visible = true

func _on_conntinue_pressed():
	$".".visible = false
	RAM.menu_in_game = false
	emit_signal("exit_menu")

func _on_exit_pressed():
	Global._saving()
	RAM.menu_in_game = false
	get_tree().change_scene("res://ui_scenes/main.tscn")
	
func _on_options_pressed():
	if RAM.in_options== false:
		$bg.visible = true
		$settings.visible = true
		$conntinue.visible = false
		$exit.visible = false
		$options.visible = false
		$White.visible = false
		Global.settings_type == "game"
		RAM.in_options = true
		RAM.exit_out_option = false

func _exit_():
	if RAM.exit_out_option == true:
		$bg.visible = false
		$settings.visible = false
		$conntinue.visible = true
		$exit.visible = true
		$options.visible = true
		$White.visible = true
		Global.settings_type == "menu"
		RAM.in_options = false	
		RAM.exit_out_option = false
		print("Get signal exit")
func _process(delta):
	if RAM.exit_out_option == true:
		$bg.visible = false
		$settings.visible = false
		$conntinue.visible = true
		$exit.visible = true
		$options.visible = true
		$White.visible = true
		Global.settings_type == "menu"
		RAM.in_options = false	
		RAM.exit_out_option = false
		print("Get signal exit")
