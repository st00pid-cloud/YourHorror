extends Control

# --- Dialogue Data ---
var dialogue_lines = [
	"Ssob, nababaliw na ako ssob",
	"Iba ang nararamdaman ko man",
	"PADILDU...",
	"Duterte ... Padilla????!?!?!?!?!",
	"TAKTE!!!!",
	"F I L I P I N O S I M U L A T I O N S T A R T"
]

# Words that trigger effects
var scary_keywords = {
	"PADILDU": "heavy_shake",
	"iba": "light_glitch",
	"nababaliw": "flash_red",
	"behind": "sudden_zoom"
}
var current_line = 0
var original_box_pos: Vector2

# --- Node References ---
# Use %UniqueNames (Right-click nodes in tree -> "Access as Unique Name")
@onready var text_label = %RichTextLabel
@onready var next_button = %NextButton
# This allows you to pick the node manually in the Inspector
@export var world_node : Node2D


	
func _ready():
	original_box_pos = next_button.position
	next_button.modulate.a = 0 # Start invisible
	show_dialogue()

func show_dialogue():
	if current_line < dialogue_lines.size():
		var current_text = dialogue_lines[current_line]
		text_label.text = current_text
		text_label.visible_ratio = 0
		next_button.modulate.a = 0
		
		# --- KEYWORD CHECKER ---
		for word in scary_keywords.keys():
			if current_text.contains(word):
				trigger_scary_effect(scary_keywords[word])
		
		# Glitchy Typewriter
		var tween = create_tween()
		tween.tween_property(text_label, "visible_ratio", 1.0, 1.2)
		tween.finished.connect(start_glitch_loop)
	else:
		start_level_transition()

func trigger_scary_effect(effect_type: String):
	match effect_type:
		"heavy_shake":
			apply_screen_shake(1.0, 25.0)
		"light_glitch":
			apply_screen_shake(0.5, 5.0)
		"flash_red":
			# Temporarily tint the whole screen red
			var t = create_tween()
			text_label.modulate = Color.RED
			t.tween_property(text_label, "modulate", Color.WHITE, 3)
		"sudden_zoom":
			# Zoom the camera in 20%
			var cam = get_viewport().get_camera_2d()
			if cam:
				var t = create_tween()
				t.tween_property(cam, "zoom", Vector2(1.2, 1.2), 0.1)
				t.tween_property(cam, "zoom", Vector2(1, 1), 0.3).set_delay(0.5)
# --- The Effects ---

func start_glitch_loop():
	next_button.modulate.a = 1.0
	var glitch_tween = create_tween().set_loops()
	
	# Random Teleport / Twitch
	glitch_tween.tween_callback(func():
		var offset = Vector2(randf_range(-4, 4), randf_range(-4, 4))
		next_button.position = original_box_pos + offset
		next_button.modulate = Color(5, 5, 5) # Bright white glitch
	).set_delay(0.05)
	
	# Reset
	glitch_tween.tween_callback(func():
		next_button.position = original_box_pos
		next_button.modulate = Color(1, 1, 1)
	).set_delay(randf_range(0.1, 0.4))

func apply_screen_shake(duration: float, intensity: float):
	# If the node wasn't assigned, don't try to shake it!
	if world_node == null:
		print("Warning: No world_node assigned for screen shake!")
		return

	var shake_tween = create_tween()
	var shake_count = int(duration / 0.05)
	var original_pos = world_node.position # Use the actual node's current pos
	
	for i in range(shake_count):
		var rand_offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		# Use world_node instead of world_content
		shake_tween.tween_property(world_node, "position", original_pos + rand_offset, 0.05)
	
	shake_tween.tween_property(world_node, "position", original_pos, 0.05)
# --- Input handling ---

func _on_next_button_pressed():
	advance_dialogue()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		advance_dialogue()

func advance_dialogue():
	if text_label.visible_ratio < 1.0:
		text_label.visible_ratio = 1.0
		start_glitch_loop()
	else:
		current_line += 1
		show_dialogue()
		
func start_level_transition():
	next_button.disabled = true
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, 1.0) # Fade UI to transparent
	fade_tween.finished.connect(func():get_tree().change_scene_to_file("res://levels/game_itself.tscn"))
