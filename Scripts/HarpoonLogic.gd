extends Node2D

onready var Main = get_parent()

func spawn_harpoon(lplayer, ground_y):
	if lplayer.current_harpoon: return
	var linstance = Harpoon.new()
	lplayer.current_harpoon = linstance
	linstance.size = Vector2(Main.harpoon_info.thickness, 0)
	linstance.pos = Vector2(
		lplayer.pos.x+lplayer.size.x/2-Main.harpoon_info.thickness/2,
		ground_y)

func del_harpoon(lplayer):
	lplayer.current_harpoon = null
