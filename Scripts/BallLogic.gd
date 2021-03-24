extends Node2D

onready var Main = get_parent()
var r_threshold2color = {20: Color('0D232E'), 15: Color('B3B088'), 10: Color('1B7F89'), 'else': Color('B59970')}

func split_ball(ball_obj):
	# delete ball_obj. Create 2 new balls. One of the balls has a -vel. Bothe have half the radius of ball_obj
	Main.ball_arr.erase(ball_obj)
	if ball_obj.radius/2 >= Main.ball_info.min_ball_radius:# if radius of new_balls>min_ball_radius
		spawn_ball(	ball_obj.pos,
					ball_obj.radius/2,
					Vector2(ball_obj.vel.x, -Main.ball_info.after_split_y_vel)
					)
		spawn_ball(	ball_obj.pos,
					ball_obj.radius/2,
					Vector2(-ball_obj.vel.x, -Main.ball_info.after_split_y_vel)
					)

func spawn_ball(lpos, r=Main.ball_info.start_radius, lvel=Vector2(Main.ball_info.x_vel, 0)):
	# defaults are suitable for balls created at the start
	var linstance = Ball.new()
	linstance.radius = r
	linstance.vel = lvel
	linstance.pos = lpos
	linstance.color = radius2color(r)
	Main.ball_arr.append(linstance)

func is_ball_to_rect_collision(lball_pos, lball_r, lrect):
	return Rect2(
		lball_pos-Vector2(lball_r, lball_r),
		Vector2(lball_r, lball_r)*2
		).intersects(lrect)

func radius2h(r, screen_h):
	var h
	if r >= 20:
		h = 0.9*screen_h
	elif r >= 15:
		h = 0.7*screen_h
	elif r >= 10:
		h = 0.5*screen_h
	else:
		h = 0.3*screen_h
	return h

func radius2y_vel(r, g, screen_h):
	var h = radius2h(r, screen_h)
	return sqrt(-2*-(h-20)*g)
	# v^2 - u^2 = 2ad => u = sqrt(v^2 - 2ad)
	# if v = 0, u = sqrt(-2ad)
	#where a = GRAVITY, d = ball max height, v = final vel, y = inital vel

func radius2color(r):
	if r >= 20:
		return r_threshold2color[20]
	elif r >= 15:
		return r_threshold2color[15]
	elif r >= 10:
		return r_threshold2color[10]
	else:
		return r_threshold2color['else']

func is_ball_to_circ_collision(lball_pos, lball_r, obs_pos, obs_r):
	var obs_to_lball = lball_pos - obs_pos
	if obs_to_lball.length() < lball_r + obs_r:
		return obs_to_lball.normalized()
