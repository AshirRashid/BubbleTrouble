extends Node2D

var P1 = Player.new()
var P2 = Player.new()
var players = [P1, P2]
var total_tiles = Vector2(25, 15)# 16x16 tiles to make up the screen
var GROUND = total_tiles.y * 16
var LEFT_WALL = 0 * 16
var RIGHT_WALL = total_tiles.x * 16
var GRAVITY = 400

var ball_info = {	'min_ball_radius': 5,
					'init_ball_x_vel': -60,
					'after_bounce_ball_y_vel': 350,
					'start_radius': 20,
					'after_split_y_vel_add': -50}
var harpoon_info = {'thickness': 4,
					'speed': 170}
var harpoon_arr = []
var ball_arr = []

func _ready():
	P1.initialize({	'pos': Vector2(RIGHT_WALL/4, GROUND-P1.size.y)})
	P2.initialize({
	'action2event_map': {	'right': 'd',
							'left': 'a',
							'attack': 'q'},
	'pos': Vector2(RIGHT_WALL/4, GROUND-P1.size.y),
	'color': Color.black})
	
	init_ball(Vector2(RIGHT_WALL/2, GROUND-ball_info.start_radius*2))
	init_ball(Vector2(3*(RIGHT_WALL/4), GROUND-ball_info.start_radius*2))

func init_ball(lpos):
	var linstance = Ball.new()
	linstance.radius = ball_info.start_radius
	linstance.vel.x = ball_info.init_ball_x_vel
	linstance.pos = lpos
	ball_arr.append(linstance)

func spawn_harpoon(lplayer, ground_y):
	if lplayer.current_harpoon: return
	var linstance = Harpoon.new()
	lplayer.current_harpoon = linstance
	linstance.size = Vector2(harpoon_info.thickness, 0)
	linstance.pos = Vector2(
		lplayer.pos.x+lplayer.size.x/2-harpoon_info.thickness/2,
		ground_y)

func _physics_process(delta):
	for lplayer in players:
		lplayer.physics_logic(delta, 0, RIGHT_WALL)
		if lplayer.should_attack():
			spawn_harpoon(lplayer, GROUND)
		
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
			lball.vel.y = -ball_info.after_bounce_ball_y_vel
		if lball.pos.x - lball.radius < 0:
			lball.vel.x *= -1
			lball.pos.x = 0+lball.radius# so it doesn't get stuck in the wall
		elif lball.pos.x + lball.radius > RIGHT_WALL:
			lball.vel.x *= -1
			lball.pos.x = RIGHT_WALL-lball.radius# so it doesn't get stuck in the wall
		
		for lplayer in players:
			if lplayer.current_harpoon:
				if is_ball_to_rect_collision(lball.pos, lball.radius, Rect2(lplayer.current_harpoon.pos, lplayer.current_harpoon.size)):
					del_harpoon(lplayer)
					split_ball(lball)
					continue
			if is_ball_to_rect_collision(lball.pos, lball.radius, Rect2(lplayer.pos, lplayer.size)):
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

func is_ball_to_rect_collision(lball_pos, lball_r, lrect):
	return Rect2(
		lball_pos-Vector2(lball_r, lball_r),
		Vector2(lball_r, lball_r)*2
		).intersects(lrect)

func del_harpoon(lplayer):
	lplayer.current_harpoon = null

func split_ball(ball_obj):
	# delete ball_obj. Create 2 new balls. One of the balls has a -vel. Bothe have half the radius of ball_obj
	ball_arr.erase(ball_obj)
	if ball_obj.radius/2 >= ball_info.min_ball_radius:# if radius of new_balls>min_ball_radius
		var linstance1 = Ball.new()
		ball_arr.append(linstance1)
		linstance1.vel = Vector2(ball_obj.vel.x, ball_obj.vel.y+ball_info.after_split_y_vel_add)
		linstance1.pos = ball_obj.pos
		linstance1.radius = ball_obj.radius/2
		
		var linstance2 = Ball.new()
		ball_arr.append(linstance2)
		linstance2.vel = Vector2(-ball_obj.vel.x, ball_obj.vel.y+ball_info.after_split_y_vel_add)
		linstance2.pos = ball_obj.pos
		linstance2.radius = ball_obj.radius/2
