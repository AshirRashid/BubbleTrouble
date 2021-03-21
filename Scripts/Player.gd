extends Resource
class_name Player

var SPEED = 120 # to be multiplied by delta time
var pos = Vector2()
var action2event_map = {'right': 'ui_right',
						'left': 'ui_left',
						'attack': 'ui_accept'}
var x_vel = Vector2() # added to player.pos.x every frame if active == true
var active = true
var size = Vector2(16, 32)
var current_harpoon
var color = Color.white

func initialize(property2val):
	for property in property2val:
		self.set(property, property2val[property])

func get_player_input()-> float:
	return Input.is_action_pressed(action2event_map['right']) as float - Input.is_action_pressed(action2event_map['left']) as float

func should_attack():
	return Input.is_action_just_pressed(action2event_map['attack'])

func physics_logic(delta, left_bound, right_bound):
	if self.active:
		self.x_vel = get_player_input() * self.SPEED
		self.pos += Vector2(self.x_vel, 0) * delta
		self.pos.x = clamp(self.pos.x, left_bound, right_bound-size.x)
