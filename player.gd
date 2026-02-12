extends CharacterBody3D

@export var sensitivity = 0.5 
@onready var head_pivot = $HeadPivot

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta):
	# 1. Get screen dimensions
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	
	# 2. Normalize the position (-0.5 to 0.5 range)
	# This turns "991 pixels" into a small, usable percentage
	var normalized_pos = Vector2(
		(mouse_pos.x / viewport_size.x) - 0.5,
		(mouse_pos.y / viewport_size.y) - 0.5
	)
	
	# 3. Apply rotation (using small radian values)
	# Horizontal: Rotate body
	rotation.y = -normalized_pos.x * sensitivity * PI
	
	# Vertical: Rotate head pivot
	head_pivot.rotation.x = -normalized_pos.y * sensitivity * PI
	head_pivot.rotation.x = clamp(head_pivot.rotation.x, deg_to_rad(-60), deg_to_rad(60))
