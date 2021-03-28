extends CanvasLayer

onready var tween = $Tween
onready var pause_menu = $PauseMenu

func _on_Pause_pressed():
	get_tree().paused = true
	pause_menu.popup()

func _on_Quit_pressed():
	get_tree().paused = false# the game will be paused bec the quit button in the pause menu
	pause_menu.hide()
	G.game2menu()

func _on_Continue_pressed():
	get_tree().paused = false
	pause_menu.hide()

func count_down():
	$CountDown.visible = true
	$CountDown.modulate = Color.transparent
	for i in range(3, -1, -1):
		$CountDown.text = i as String
		tween.interpolate_property($CountDown, 'modulate', $CountDown.modulate, Color.white, 0.5)
		tween.start()
		yield(tween, "tween_completed")
		yield(get_tree().create_timer(0.2), "timeout")
		
		tween.interpolate_property($CountDown, 'modulate', $CountDown.modulate, Color.transparent, 0.1)
		tween.start()
		yield(tween, "tween_all_completed")
	$CountDown.visible = false
	$CountDown.modulate = Color.white
