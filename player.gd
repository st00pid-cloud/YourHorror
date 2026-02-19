extends CharacterBody3D

# --- Calibration Variables ---
@export var sensitivity = 0.1 #  this if the camera moves too far
@export var smoothness = 50.0  # Higher makes the arm follow the cursor faster
@onready var head_pivot = $HeadPivot

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	
	# 1. Normalize position
	var normalized_pos = Vector2(
		(mouse_pos.x / viewport_size.x) - 0.5,
		(mouse_pos.y / viewport_size.y) - 0.5
	)
	
	# 2. Calculate target rotation
	# We use a smaller multiplier to keep the arm aligned with the cursor
	var target_y = -normalized_pos.x * (sensitivity * PI)
	var target_x = -normalized_pos.y * (sensitivity * PI)
	
	# 3. Apply smooth rotation
	rotation.y = lerp_angle(rotation.y, target_y, smoothness * delta)
	
	var pitch_clamped = clamp(target_x, deg_to_rad(-60), deg_to_rad(60))
	head_pivot.rotation.x = lerp_angle(head_pivot.rotation.x, pitch_clamped, smoothness * delta)
