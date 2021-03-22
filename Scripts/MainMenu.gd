extends Control

var level_buttons = []
var player_num

func _on_Play_pressed():
	$PlayerSelection.popup()

func _on_LSelBack_pressed():
	$PlayerSelection.popup()
	$LevelSelection.hide()
	clear_level_buttons()

func _on_SettingsCancel_pressed():
	$SettingsMenu.hide()

func _on_Save_pressed():
	G.set_settings_to_file({
		'left': $SettingsMenu/V/G/left.rect_global_position,
		'right': $SettingsMenu/V/G/right.rect_global_position,
		'shoot': $SettingsMenu/V/G/shoot.rect_global_position
	})
	$SettingsMenu.hide()

func _on_PSelBack_pressed():
	$PlayerSelection.hide()

func _on_Settings_pressed():
	$SettingsMenu.popup()

func _on_1Player_pressed():
	player_num = 1
	show_level_selection()

func _on_2Player_pressed():
	player_num = 2
	show_level_selection()

func show_level_selection():
	for i in range(1, G.levels.keys()[-1]+1):
		var linstance = Button.new()
		linstance.text = i as String
		level_buttons.append(linstance)
		linstance.connect('pressed', self, 'level_selected', [i])
		$LevelSelection/V/MC/G.add_child(linstance)
	$LevelSelection.popup()

func level_selected(level_id):
	var level_dict = G.levels[level_id]
	level_dict.player_num = player_num
	G.menu2game(level_dict)
	clear_level_buttons()

func clear_level_buttons():
	for level_button in level_buttons:
		level_button.queue_free()
