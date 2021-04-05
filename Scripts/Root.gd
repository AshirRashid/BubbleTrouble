extends Control

func menu2game(level_dict):
	get_tree().change_scene_to(G.Main)
	yield(get_tree().create_timer(0.01), "timeout")
	get_tree().current_scene.load_level(level_dict)
