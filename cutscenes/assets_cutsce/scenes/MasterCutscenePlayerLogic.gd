extends Control
# --- Data Input ---
@export var cutscene_resource: CutsceneData

# --- Node References --- 
@onready var choice_container = %ChoiceContainer
@onready var choice_button_1 = %Choice1
@onready var choice_button_2 = %Choice2
@onready var error_overlay = %ErrorScreen
@onready var go_back_button = %GoBackButton 
@onready var text_label = %RichTextLabel
@onready var next_button = %NextButton

@export var world_node : Node2D 

var current_line = 0
var original_box_pos: Vector2
var active_glitch: Tween

# Words that trigger effects
var scary_keywords = {
	"pull": "heavy_shake",
	"anything": "light_glitch",
	"buffering": "flash_red",
	"should": "flash_red",
	"breathing": "sudden_zoom"
}
	
func _ready():
	if not cutscene_resource:
		push_error("No CutsceneData assigned to the Player!")
		return
		
	original_box_pos = next_button.position
	next_button.modulate.a = 0 
	error_overlay.hide()
	show_dialogue()

func show_dialogue():
	# Access data from the resource instead of hardcoded variables
	var lines = cutscene_resource.dialogue_lines
	var keywords = cutscene_resource.scary_keywords
	
	if current_line < lines.size():
		var current_text = lines[current_line]
		
		# Choice Detection
		if "[YES | YES]" in current_text:
			next_button.hide()
			setup_choices()
		else:
			choice_container.hide()
			next_button.show()
			
		text_label.text = current_text.replace("[YES | YES]", "")
		text_label.visible_ratio = 0
		
		# Keyword Effects
		for word in keywords.keys():
			if current_text.contains(word):
				trigger_scary_effect(keywords[word])
		
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
	fade_tween.tween_property(self, "modulate:a", 0.0, 1.0)
	fade_tween.finished.connect(func():
		get_tree().change_scene_to_file("res://levels/game_itself.tscn")
	)
func setup_choices(text: String):
	choice_container.show()
	choice_button_1.text = "YES"
	
	# Start the Glitch loop for the second button
	var choice_glitch = create_tween().set_loops()
	choice_glitch.tween_callback(func():
		var fake_options = ["YES", "NO", "SYSTEM_FAILURE", "NULL"]
		choice_button_2.text = fake_options.pick_random()
		choice_button_2.modulate = Color(10, 0, 0) # Glowing red
	).set_delay(0.1)
	
	choice_glitch.tween_callback(func():
		choice_button_2.text = "YES"
		choice_button_2.modulate = Color.WHITE
	).set_delay(0.4)

# Connected to Choice 1 (The "Safe" Yes)
func _on_choice_1_pressed():
	current_line += 1
	show_dialogue()

# Connected to Choice 2 (The Glitchy Yes)
func _on_choice_2_pressed():
	trigger_error_screen()

func trigger_error_screen():
	error_overlay.show()
	# Disable other inputs while error is active
	next_button.disabled = true
	choice_button_1.disabled = true
	choice_button_2.disabled = true
	
	# Apply a heavy shake because the system "crashed"
	apply_screen_shake(0.5, 20.0)

func _on_go_back_pressed():
	error_overlay.hide()
	
	# Re-enable buttons
	next_button.disabled = false
	choice_button_1.disabled = false
	choice_button_2.disabled = false
	
	# Logic choice: Do you want them to try again or move on?
	# To move to the next line of dialogue:
	current_line += 1
	show_dialogue()


func _on_go_back_button_pressed() -> void:
	pass # Replace with function body.
