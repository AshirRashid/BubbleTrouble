extends Control

func _ready():
	for i in range(1, G.levels.keys()[-1]+1):
		var linstance = Button.new()
		linstance.text = i as String
		linstance.connect('pressed', self, 'level_selected', [i])
		$LevelSelection/V/MC/G.add_child(linstance)

func _on_Play_pressed():
	$LevelSelection.popup()

func _on_Settings_pressed():
	$SettingsMenu.popup()
func _on_SettingsCancel_pressed():
	$SettingsMenu.hide()
func _on_Save_pressed():
	G.set_settings_to_file({
		'left': $SettingsMenu/V/G/left.rect_global_position,
		'right': $SettingsMenu/V/G/right.rect_global_position,
		'shoot': $SettingsMenu/V/G/shoot.rect_global_position
	})
	$SettingsMenu.hide()

func level_selected(level_id):
	var level_dict = G.levels[level_id]
	G.menu2game(level_dict)
func _on_LSelBack_pressed():
	$LevelSelection.hide()

