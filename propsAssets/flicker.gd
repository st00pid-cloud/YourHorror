extends StaticBody3D

# Matches your scene tree in image_506cfc.png
@onready var paper_node = $"poster assembled/Paper"

func _ready():
	# Crucial for mouse detection in Godot 4.5
	input_ray_pickable = true
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	# This forces the mesh instance to update its specific material energy
	var mat = paper_node.get_active_material(0)
	if mat:
		mat.set_deferred("emission_enabled", true)
		mat.set_deferred("emission_energy_multiplier", 3.0) # Increased for visibility
		print("Glow turned ON") # Check your Output console for this!

func _on_mouse_exited():
	var mat = paper_node.get_active_material(0)
	if mat:
		mat.set_deferred("emission_energy_multiplier", 0.0)
		print("Glow turned OFF")

func _input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Calls the dialogue UI
		get_tree().call_group("DialogueSystem", "display_text", "It's an old flyer for a missing person. The paper feels cold.")
