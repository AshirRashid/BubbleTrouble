extends Control

export(Texture) var texture

onready var tween = $Tween

var window_size = Vector2(720, 400)
var pos_r_arr = []
var bubbles_info = {
	'max_r': 35, 'min_r': 15, 'pop_r': 5,
	'common_ratio': 0.995,
	'vel': Vector2(0, 60)
	}

func gen_bubbles(n=1):
	randomize()
	for i in range(n):
		pos_r_arr.append({
			'pos': 	Vector2(bubbles_info['max_r']+
					randf()*(window_size.x-bubbles_info['max_r']*2), window_size.y),
			'r':	bubbles_info['min_r'] + randf()*(bubbles_info['max_r']-bubbles_info['min_r'])
			})

func _physics_process(delta):
	for lpos_r in pos_r_arr:
		lpos_r['pos'] -= bubbles_info['vel']*delta
		lpos_r['r'] *= bubbles_info['common_ratio']
		if lpos_r['r'] <= bubbles_info['pop_r']:
			pos_r_arr.erase(lpos_r)
	update()

func _input(event):
	if !event is InputEventMouseButton or !event.is_pressed(): return
	var click_pos = event.position
	for lpos_r in pos_r_arr:
		if (lpos_r['pos']+Vector2(lpos_r['r'], lpos_r['r']) - click_pos).length() <= lpos_r['r']:
			pos_r_arr.erase(lpos_r)

func reset_bubbles():
	$Timer1.start(); $Timer2.start(); $Timer3.start()
	bubbles_info.vel = Vector2(0, 60)
	bubbles_info.common_ratio = 0.995

func speed_up():
	bubbles_info.vel *= 3.3
	bubbles_info.common_ratio = 0.983

func on_level_selection():
	speed_up()
	$Timer1.stop(); $Timer2.stop(); $Timer3.stop()
	
func _on_Timer_timeout():
	gen_bubbles(randi() % 2 + 1)# generate one or two bubbles

func _draw():
	for lpos_r in pos_r_arr:
		var scale = (2.0*lpos_r['r'])/texture.get_height()# given that the texture has equal width and height, we don't need to do the same thing twice.
		draw_set_transform(
			Vector2(),
			0.0,
			Vector2(scale, scale))
		draw_texture(
			texture,
			lpos_r['pos']/scale# cancel out scale affect on positioning
			)
		draw_set_transform(Vector2(), 0.0, Vector2(1, 1))
