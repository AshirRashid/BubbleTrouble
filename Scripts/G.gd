extends Node

var MainMenu = load('res://Scenes/MainMenu.tscn')
var Main = load('res://Scenes/Main.tscn')
var settings_file_name = 'settings'

var TOTAL_TILES = Vector2(45, 25)# 16x16 tiles to make up the screen
var CEILING = 0 * 16 
var GROUND = (TOTAL_TILES.y-5) * 16
var LEFT_WALL = 0 * 16
var RIGHT_WALL = TOTAL_TILES.x * 16

var levels = {# order is important for displaying in Level Seclection
	1: {
		'radius2num': {30: 1}
	},
	2: {
		'radius2num': {20: 2}
	},
	3: {
		'radius2num': {20: 1, 10: 3}
	},
	4: {
		'radius2num': {5: 8}
	},
	5: {
		'radius2num': {100: 1}
	},
	6: {
		'radius2num': {5: 5, 10: 5}
	},
	7: {
		'radius2num': {5: 4, 10: 2},
		'circ_obs2info_arr': [{
			'pos': Vector2(RIGHT_WALL/2, GROUND),
			'r': 35, 'color': Color.black}]
	},
	8: {
		'radius2num': {20: 2},
		'circ_obs2info_arr': [
			{
			'pos': Vector2(RIGHT_WALL*0.25, GROUND),
			'r': 35, 'color': Color.black},
			{
			'pos': Vector2(RIGHT_WALL*0.75, GROUND),
			'r': 35, 'color': Color.black}
			]
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
	yield(get_tree().create_timer(0.05), "timeout")
	get_tree().current_scene.load_level(level_dict)

func game2menu():
	get_tree().change_scene_to(MainMenu)
