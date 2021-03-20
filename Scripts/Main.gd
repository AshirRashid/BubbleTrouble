extends Node2D

export var harpoon_packscn: PackedScene
export var ball_packscn: PackedScene

var total_tiles = Vector2(25, 15)# 16x16 tiles to make up the screen
var GROUND = total_tiles.y * 16
var LEFT_WALL = 0 * 16
var RIGHT_WALL = total_tiles.x * 16
var GRAVITY = 400

var ball_info = {	'min_ball_radius': 5,
					'init_ball_x_vel': -60,
					'after_bounce_ball_y_vel': 350,
					'start_radius': 20}
var harpoon_info = {'thickness': 4,
					'speed': 170}
var harpoon_arr = []
var ball_arr = []

func _ready():
	Player.pos = Vector2(RIGHT_WALL/2, GROUND-Player.size.y)
	init_ball()

func init_ball():
	var linstance = ball_packscn.instance()
	linstance.radius = ball_info.start_radius
	linstance.vel.x = ball_info.init_ball_x_vel
	linstance.pos = Vector2(RIGHT_WALL/2, GROUND-linstance.radius*2)
	ball_arr.append(linstance)

func spawn_harpoon(x_pos, ground_y):
	if Player.current_harpoon: return
	var linstance = harpoon_packscn.instance()
	Player.current_harpoon = linstance
	linstance.size = Vector2(harpoon_info.thickness, 0)
	linstance.pos = Vector2(x_pos, ground_y)

func _physics_process(delta):
	Player.physics_logic(delta, 0, RIGHT_WALL)
	if Player.should_attack():
		spawn_harpoon(Player.pos.x, GROUND)
		
	if Player.current_harpoon: # move the harpoon up
		Player.current_harpoon.size.y += harpoon_info.speed * delta
		Player.current_harpoon.pos.y -= harpoon_info.speed * delta
		if Player.current_harpoon.size.y > GROUND: # if harpoon.y > screen_size.y: delete it
			Player.current_harpoon = null
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
		
		if Player.current_harpoon:
			if is_ball_to_rect_collision(lball.pos, lball.radius, Rect2(Player.current_harpoon.pos, Player.current_harpoon.size)):
				del_harpoon()
				split_ball(lball)
				continue
	update()

func _draw():
	draw_rect(Rect2(Player.pos, Player.size), Color.white)
	if Player.current_harpoon:
		draw_rect(
			Rect2(	Player.current_harpoon.pos,
					Player.current_harpoon.size),
			Color.red)
	for lball in ball_arr:
		draw_circle(lball.pos, lball.radius, lball.color)

func is_ball_to_rect_collision(lball_pos, lball_r, lrect):
	return Rect2(
		lball_pos-Vector2(lball_r, lball_r),
		Vector2(lball_r, lball_r)*2
		).intersects(lrect)

func del_harpoon():
	Player.current_harpoon.queue_free()
	Player.current_harpoon = null

func split_ball(ball_obj):
	# delete ball_obj. Create 2 new balls. One of the balls has a -vel. Bothe have half the radius of ball_obj
	ball_arr.erase(ball_obj)
	if ball_obj.radius/2 >= ball_info.min_ball_radius:# if radius of new_balls>min_ball_radius
		var linstance1 = ball_packscn.instance()
		ball_arr.append(linstance1)
		linstance1.vel = ball_obj.vel
		linstance1.pos = ball_obj.pos
		linstance1.radius = ball_obj.radius/2
		
		var linstance2 = ball_packscn.instance()
		ball_arr.append(linstance2)
		linstance2.vel = Vector2(-ball_obj.vel.x, ball_obj.vel.y)
		linstance2.pos = ball_obj.pos
		linstance2.radius = ball_obj.radius/2
	ball_obj.queue_free()
