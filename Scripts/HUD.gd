extends CanvasLayer

onready var pause_menu = $PauseMenu

func _on_Pause_pressed():
	get_tree().paused = true
	pause_menu.popup()

func _on_Quit_pressed():
	G.game2menu()

func _on_Continue_pressed():
	get_tree().paused = false
	pause_menu.hide()
