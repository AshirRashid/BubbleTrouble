extends CanvasLayer

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
