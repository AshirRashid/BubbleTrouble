extends Control

onready var controls_container = $SettingsMenu/V/G

func _ready():
	for i in range(1, G.levels.keys()[-1]+1):
		var linstance = Button.new()
		linstance.text = i as String
		linstance.connect('pressed', self, 'level_selected', [i])
		$LevelSelection/V/MC/G.add_child(linstance)

func _on_Play_pressed():
	$LevelSelection.popup()

func load_settings(settings_dict):
	controls_container.get_node("left").rect_global_position = settings_dict.left
	controls_container.get_node("right").rect_global_position = settings_dict.right
	controls_container.get_node("shoot").rect_global_position = settings_dict.shoot
func _on_Settings_pressed():
	load_settings(G.get_settings_from_file())
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
