extends Node2D

@onready var sprite = $Sprite2D

# Load your different textures here
var textures = {
	"default": preload("res://propsAssets/crosshair087.png"),
	"interact": preload("res://propsAssets/crosshair029.png"),
	"attack": preload("res://propsAssets/crosshair139.png")
}

func _ready():
	# This hides the system cursor AND keeps it stuck inside the game window
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

func _process(_delta):
	# Follow the mouse precisely every frame
	global_position = get_global_mouse_position()

# Call this function from other parts of your game
func change_cursor(state: String):
	if textures.has(state):
		sprite.texture = textures[state]
		
