extends Control
#TODO: create multiple bubbles for same radius bubble.
export(Texture) var texture

onready var BgBubbleGen = get_parent().get_parent().get_parent().get_node("Bg/BubbleGenBg")
onready var tween = $Tween

var window_size = Vector2(720, 400)

func gen_level_bubbles(level_dict):
	var full_ground = G.TOTAL_TILES.y*16
	BgBubbleGen.on_level_selection()
	var ball2final_pos = {}
	var r2num = level_dict.radius2num
	for r in r2num.keys():
		if r2num[r] > 1:
			var step = floor( G.RIGHT_WALL/r2num[r] )
			for x_pos in range(step/2, G.RIGHT_WALL+1, step):
				var lsprite = create_bubble_sprite(r)
				tween.interpolate_property(lsprite, 'global_position',
				Vector2(x_pos, full_ground),
				Vector2(x_pos, G.GROUND-Utils.radius2h(r, G.GROUND)), 1)
		else:
			var lsprite = create_bubble_sprite(r)
			var x_pos = G.RIGHT_WALL/2
			tween.interpolate_property(lsprite, 'global_position',
			Vector2(x_pos, full_ground),
			Vector2(x_pos, G.GROUND-Utils.radius2h(r, G.GROUND)), 1)
		tween.start()

	yield(get_tree().create_timer(0.6), 'timeout')
	get_parent().hide()
	G.menu2game(level_dict)

func create_bubble_sprite(bubble_r):
	var lsprite = Sprite.new()
	self.add_child(lsprite)
	lsprite.texture = texture
	var scale_x = (2.0*bubble_r)/lsprite.get_rect().size.x
	lsprite.scale = Vector2(scale_x, scale_x)
	return lsprite
