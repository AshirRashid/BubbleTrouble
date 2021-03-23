extends Node

var MainMenu = load('res://Scenes/MainMenu.tscn')
var Main = load('res://Scenes/Main.tscn')
var settings_file_name = 'settings'

var levels = {# order is important for displaying in Level Seclection
	1: {
		'radius2num': {50: 1}
	}
}

func set_settings_to_file(val):
	var file = File.new()
	file.open(settings_file_name, File.WRITE)
	file.store_var(val)
	file.close()

func get_settings_from_file():
	var file = File.new()
	file.open(settings_file_name, File.READ)
	var return_val = file.get_var()
	file.close()
	return return_val

func menu2game(level_dict):
	get_tree().change_scene_to(Main)
	yield(get_tree().create_timer(0.1), "timeout")
	get_tree().current_scene.load_level(level_dict)

func game2menu():
	get_tree().change_scene_to(MainMenu)
