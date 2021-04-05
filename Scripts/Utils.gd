extends Node

var r_threshold2color = {20: Color('0D232E'), 15: Color('B3B088'), 10: Color('1B7F89'), 'else': Color('B59970')}

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
