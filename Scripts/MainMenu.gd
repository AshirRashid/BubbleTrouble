extends CanvasLayer

onready var tween = $Tween
onready var controls_container = $SettingsMenu/V/G

var trans_time = 0.4

func _ready():
	for i in range(1, G.levels.keys()[-1]+1):
		var linstance = Button.new()
		linstance.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		linstance.size_flags_vertical = Control.SIZE_EXPAND_FILL
		linstance.text = i as String
		linstance.connect('pressed', self, 'level_selected', [i])
		$LevelSelection/V/MC/G.add_child(linstance)

func _on_Play_pressed():
	get_parent().get_node("Bg/BubbleGenBg").reset_bubbles()
	$LevelSelection.popup()
	tween.interpolate_property($LevelSelection, 'rect_position', Vector2(-G.TOTAL_TILES.x*16, 0), Vector2.ZERO, trans_time)
	tween.interpolate_property($Control, 'rect_position', Vector2.ZERO, Vector2(G.TOTAL_TILES.x*16, 0), trans_time)
	tween.start()

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
	
	$LevelSelection/BubbleGen.gen_level_bubbles(G.levels[level_id])
func _on_LSelBack_pressed():
	tween.interpolate_property($Control, 'rect_position', Vector2(G.TOTAL_TILES.x*16, 0), Vector2.ZERO, trans_time)
	tween.interpolate_property($LevelSelection, 'rect_position', Vector2.ZERO, Vector2(-G.TOTAL_TILES.x*16, 0), trans_time)
	tween.start()
