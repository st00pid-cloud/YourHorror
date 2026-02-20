extends Node3D
@export_group("Leaning")
@export var lean_amount := 0.05
@export var lean_smoothness := 7.0 
@export_group("Sensitivity & Smoothing")
@export var sensitivity := 0.002
@export var smoothness := 15.0

@export_group("Head Bob")
@export var bob_freq := 2.0
@export var bob_amp := 0.05
var _bob_timer := 0.0

var _target_rot_x := 0.0
var _target_rot_y := 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_target_rot_y = get_parent().rotation.y
	_target_rot_x = rotation.x

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_target_rot_y -= event.relative.x * sensitivity
		_target_rot_x -= event.relative.y * sensitivity
		_target_rot_x = clamp(_target_rot_x, -PI/2, PI/2)

func _process(delta: float) -> void:
	get_parent().rotation.y = lerp_angle(get_parent().rotation.y, _target_rot_y, delta * smoothness)
	rotation.x = lerp_angle(rotation.x, _target_rot_x, delta * smoothness)
	
	_handle_head_bob(delta)
	
	_handle_lean(delta)

func _handle_head_bob(delta: float) -> void:
	var velocity = get_parent().velocity
	var horizontal_velocity = Vector2(velocity.x, velocity.z).length()
	
	if horizontal_velocity > 0.1:
		_bob_timer += delta * horizontal_velocity * bob_freq
		var bob_offset = sin(_bob_timer) * bob_amp
		position.y = lerp(position.y, bob_offset, delta * smoothness)
	else:
		_bob_timer = 0
		position.y = lerp(position.y, 0.0, delta * smoothness)

func _handle_lean(delta: float) -> void:
	var target_z := 0.0
	
	if Input.is_action_pressed("lean_left"):
		target_z = lean_amount
	elif Input.is_action_pressed("lean_right"):
		target_z = -lean_amount
		
	rotation.z = lerp_angle(rotation.z, target_z, delta * lean_smoothness)
