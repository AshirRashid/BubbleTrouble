extends Node2D

onready var BallLogic = $BallLogic
onready var HarpoonLogic = $HarpoonLogic
onready var HUD = $HUD

var P1
var GRAVITY = 400

var ball_info = {	'min_ball_radius': 5,
					'x_vel': -60,
					'max_h': G.GROUND,
					'start_radius': 20,
					'after_split_y_vel': 150}
var harpoon_info = {'thickness': 4,
					'speed': 190}
var harpoon_arr = []
var ball_arr = []
var circ_obstacle_arr = []#circular obstacles are dicts with center and radius properties

func _ready():
	set_physics_process(false)

func load_settings(settings_dict):
	HUD.get_node("left").rect_global_position = settings_dict.left
	HUD.get_node("right").rect_global_position = settings_dict.right
	HUD.get_node("shoot").rect_global_position = settings_dict.shoot

func load_level(level):
	load_settings(G.get_settings_from_file())
	P1 = Player.new()
	P1.initialize({	'pos': Vector2(G.RIGHT_WALL/4, G.GROUND-P1.size.y)})
	var r2num = level.radius2num
	var r_arr = r2num.keys()
	r_arr.sort(); r_arr.invert()
	for r in r_arr:
		if r2num[r] > 1:
			var step = floor( G.RIGHT_WALL/r2num[r] )
			for x_pos in range(step/2, G.RIGHT_WALL, step):
				BallLogic.spawn_ball(
					Vector2(x_pos,
					G.GROUND-Utils.radius2h(r, G.GROUND)),
					r, Vector2(ball_info.x_vel, 0))
		else:
			BallLogic.spawn_ball(
				Vector2(G.RIGHT_WALL/2,
				G.GROUND-Utils.radius2h(r, G.GROUND)),
				r, Vector2(ball_info.x_vel, 0))
			
	circ_obstacle_arr = level.get('circ_obs2info_arr', [])
	
	# wait for countdown function to complete and then set the physics process
	update()
	yield(HUD.count_down(), 'completed')
	self.set_physics_process(true)

func _physics_process(delta):
	P1.movement_logic(delta, 0, G.RIGHT_WALL, HUD)
	if P1.should_attack(HUD):
		HarpoonLogic.spawn_harpoon(P1, G.GROUND)
	
	if P1.current_harpoon: # move the harpoon up
		P1.current_harpoon.size.y += harpoon_info.speed * delta
		P1.current_harpoon.pos.y -= harpoon_info.speed * delta
		if P1.current_harpoon.size.y > G.GROUND: # if harpoon.y > screen_size.y: delete it
			P1.current_harpoon = null
				
	for lball in ball_arr:
		# move the ball
		lball.vel.y += GRAVITY * delta
		lball.pos += lball.vel * delta
		# check collision and adjust position
		if lball.pos.y + lball.radius > G.GROUND:
			lball.pos.y = G.GROUND-lball.radius# so it doesn't get stuck in the wall
			lball.vel.y = -Utils.radius2y_vel(lball.radius, GRAVITY, ball_info.max_h)
		if lball.pos.x - lball.radius < 0:
			lball.vel.x *= -1
			lball.pos.x = 0+lball.radius# so it doesn't get stuck in the wall
		elif lball.pos.x + lball.radius > G.RIGHT_WALL:
			lball.vel.x *= -1
			lball.pos.x = G.RIGHT_WALL-lball.radius# so it doesn't get stuck in the wall
		
		if P1.current_harpoon:
			if BallLogic.is_ball_to_rect_collision(lball.pos, lball.radius, Rect2(P1.current_harpoon.pos, P1.current_harpoon.size)):
				HarpoonLogic.del_harpoon(P1)
				BallLogic.split_ball(lball)
				continue
		if BallLogic.is_ball_to_rect_collision(lball.pos, lball.radius, Rect2(P1.pos, P1.size)):
			G.game2menu()
		for circ_obs in circ_obstacle_arr:
			var normal_vec = BallLogic.is_ball_to_circ_collision(lball.pos, lball.radius, circ_obs.pos, circ_obs.r)
			if normal_vec:
				lball.vel = normal_vec * lball.vel.length()
		
	if ball_arr.size() == 0:
		G.game2menu()
		
	update()

func _draw():
	if P1:
		draw_rect(Rect2(P1.pos, P1.size), P1.color)
		if P1.current_harpoon:
			draw_rect(
				Rect2(	P1.current_harpoon.pos,
						P1.current_harpoon.size),
				Color.red)
	for lball in ball_arr:
		draw_circle(lball.pos, lball.radius, lball.color)
	for lcirc_obs in circ_obstacle_arr:
		draw_circle(lcirc_obs.pos, lcirc_obs.r, lcirc_obs.color)
	#draw ground
	draw_rect(
		Rect2(Vector2(0, G.GROUND),
		Vector2(G.RIGHT_WALL, G.GROUND)),
		Color.black,  (G.TOTAL_TILES.y*16) - G.GROUND
		)
