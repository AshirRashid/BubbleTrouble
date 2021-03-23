extends Node2D

onready var BallLogic = $BallLogic
onready var HarpoonLogic = $HarpoonLogic
onready var HUD = $HUD

var P1
var P2
var players = []
var total_tiles = Vector2(45, 25)# 16x16 tiles to make up the screen
var CEILING = 0 * 16 
var GROUND = (total_tiles.y-5) * 16
var LEFT_WALL = 0 * 16
var RIGHT_WALL = total_tiles.x * 16
var GRAVITY = 400

var ball_info = {	'min_ball_radius': 5,
					'x_vel': -60,
					'max_h': GROUND,
					'start_radius': 20,
					'after_split_y_vel': 150}
var harpoon_info = {'thickness': 4,
					'speed': 190}
var harpoon_arr = []
var ball_arr = []

func _ready():
	set_physics_process(false)

func load_settings(settings_dict):
	HUD.get_node("left").rect_global_position = settings_dict.left
	HUD.get_node("right").rect_global_position = settings_dict.right
	HUD.get_node("shoot").rect_global_position = settings_dict.shoot

func load_level(level):
	load_settings(G.get_settings_from_file())
	P1 = Player.new()
	P1.initialize({	'pos': Vector2(RIGHT_WALL/4, GROUND-P1.size.y)})
	players = [P1]
	if level.player_num > 1:
		P2 = Player.new()
		P2.initialize({
		'action2event_map': {	'right': 'd',
							'left': 'a',
							'attack': 'q'},
		'pos': Vector2(RIGHT_WALL/4, GROUND-P1.size.y),
		'color': Color.black})
		players.append(P2)
	var r2num = level.radius2num
	var r_arr = r2num.keys()
	r_arr.sort(); r_arr.invert()
	for r in r_arr:
		if r2num[r] > 1:
			var step = floor( (RIGHT_WALL-2*r)/(r2num[r]-1) )
			for x_pos in range(r, RIGHT_WALL-r+1, step):
				BallLogic.spawn_ball(Vector2(x_pos, BallLogic.radius2h(r, GROUND)), r, Vector2(ball_info.x_vel, 0))
		else:
			BallLogic.spawn_ball(Vector2(RIGHT_WALL/2, BallLogic.radius2h(r, GROUND)), r, Vector2(ball_info.x_vel, 0))
	self.set_physics_process(true)

func _physics_process(delta):
	for lplayer in players:
		print(lplayer)
		lplayer.movement_logic(delta, 0, RIGHT_WALL, HUD)
		if lplayer.should_attack(HUD):
			HarpoonLogic.spawn_harpoon(lplayer, GROUND)
		
		if lplayer.current_harpoon: # move the harpoon up
			lplayer.current_harpoon.size.y += harpoon_info.speed * delta
			lplayer.current_harpoon.pos.y -= harpoon_info.speed * delta
			if lplayer.current_harpoon.size.y > GROUND: # if harpoon.y > screen_size.y: delete it
				lplayer.current_harpoon = null
				
	for lball in ball_arr:
		# move the ball
		lball.vel.y += GRAVITY * delta
		lball.pos += lball.vel * delta
		# check collision and adjust position
		if lball.pos.y + lball.radius > GROUND:
			lball.pos.y = GROUND-lball.radius# so it doesn't get stuck in the wall
			lball.vel.y = -BallLogic.radius2y_vel(lball.radius, GRAVITY, ball_info.max_h)
		if lball.pos.x - lball.radius < 0:
			lball.vel.x *= -1
			lball.pos.x = 0+lball.radius# so it doesn't get stuck in the wall
		elif lball.pos.x + lball.radius > RIGHT_WALL:
			lball.vel.x *= -1
			lball.pos.x = RIGHT_WALL-lball.radius# so it doesn't get stuck in the wall
		
		for lplayer in players:
			if lplayer.current_harpoon:
				if BallLogic.is_ball_to_rect_collision(lball.pos, lball.radius, Rect2(lplayer.current_harpoon.pos, lplayer.current_harpoon.size)):
					HarpoonLogic.del_harpoon(lplayer)
					BallLogic.split_ball(lball)
					continue
			if BallLogic.is_ball_to_rect_collision(lball.pos, lball.radius, Rect2(lplayer.pos, lplayer.size)):
				print('player lost')
	if ball_arr.size() == 0:
		print('player win')
		
	update()

func _draw():
	for lplayer in players:
		draw_rect(Rect2(lplayer.pos, lplayer.size), lplayer.color)
		if lplayer.current_harpoon:
			draw_rect(
				Rect2(	lplayer.current_harpoon.pos,
						lplayer.current_harpoon.size),
				Color.red)
	for lball in ball_arr:
		draw_circle(lball.pos, lball.radius, lball.color)
	#draw ground
	draw_rect(
		Rect2(Vector2(0, GROUND),
		Vector2(RIGHT_WALL, GROUND)),
		Color.black,  (total_tiles.y*16) - GROUND
		)
