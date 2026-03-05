extends Node2D

@onready var sprite = $Sprite2D

var textures = {
	"default": preload("res://propsAssets/crosshair087.png"),
	"interact": preload("res://propsAssets/crosshair029.png"),
	"attack": preload("res://propsAssets/crosshair139.png")
}

func _ready():
	# CAPTURED is essential for 3D navigation. 
	# It locks the mouse to the center and allows infinite movement.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Center the sprite on the screen initially
	var screen_size = get_viewport_rect().size
	global_position = screen_size / 2

func _process(_delta):
	# In CAPTURED mode, the mouse doesn't "move" positions, 
	# so we keep the crosshair locked to the center of the screen.
	var screen_size = get_viewport_rect().size
	global_position = screen_size / 2

func _input(event):
	# Toggle back to mouse visible if player hits escape (good for debugging)
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func change_cursor(state: String):
	if textures.has(state):
		sprite.texture = textures[state]
