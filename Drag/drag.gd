extends Control

onready var node_to_move: Node = get_parent()
onready var move_on: Array = [get_parent()]
var mouse_store: Vector2 = Vector2.ZERO

func _ready():
	for node in move_on:
		node.connect('gui_input', self, 'on_drag_gui_input')

func on_drag_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			mouse_store = node_to_move.rect_position - get_global_mouse_position()
		else:
			mouse_store = Vector2.ZERO

	if event is InputEventMouseMotion:
		if mouse_store:
			node_to_move.rect_position = get_global_mouse_position() + mouse_store

