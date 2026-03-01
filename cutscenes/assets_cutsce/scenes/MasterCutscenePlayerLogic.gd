extends Control

## --- Data Input ---
@export var cutscene_resource: CutsceneData
@export var world_node: Node2D 

## --- Node References --- 
@onready var choice_container: Control = %ChoiceContainer
@onready var choice_button_1: Button = %Choice1
@onready var choice_button_2: Button = %Choice2
@onready var error_overlay: Control = %ErrorScreen
@onready var text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton

var current_line: int = 0
var original_button_pos: Vector2
var active_tween: Tween
var glitch_loop: Tween

func _ready() -> void:
	if not cutscene_resource:
		push_error("No CutsceneData assigned!")
		return
		
	original_button_pos = next_button.position
	next_button.modulate.a = 0 
	error_overlay.hide()
	show_dialogue()

## --- Core Logic ---

func show_dialogue() -> void:
	var lines = cutscene_resource.dialogue_lines
	var keywords = cutscene_resource.scary_keywords
	
	if current_line >= lines.size():
		start_level_transition()
		return

	var current_text = lines[current_line]
	_kill_active_tweens()
	
	# Handle Choice UI State
	var is_choice = "[YES | YES]" in current_text
	next_button.visible = not is_choice
	choice_container.visible = is_choice
	
	if is_choice:
		setup_choices()
	
	# Text Setup
	text_label.text = current_text.replace("[YES | YES]", "")
	text_label.visible_ratio = 0.0
	
	# Check for Keywords
	for word in keywords.keys():
		if current_text.contains(word):
			trigger_scary_effect(keywords[word])
	
	# Animate Text reveal
	active_tween = create_tween()
	active_tween.tween_property(text_label, "visible_ratio", 1.0, 1.2)
	active_tween.finished.connect(start_glitch_loop)

func advance_dialogue() -> void:
	if text_label.visible_ratio < 1.0:
		text_label.visible_ratio = 1.0
		if active_tween: active_tween.kill()
		start_glitch_loop()
	elif next_button.visible: # Only advance if not stuck on a choice
		current_line += 1
		show_dialogue()

## --- Effects & Animations ---

func trigger_scary_effect(effect_type: String) -> void:
	match effect_type:
		"heavy_shake": apply_screen_shake(1.0, 25.0)
		"light_glitch": apply_screen_shake(0.5, 5.0)
		"flash_red":
			var t = create_tween()
			text_label.modulate = Color.RED
			t.tween_property(text_label, "modulate", Color.WHITE, 1.5)
		"sudden_zoom":
			var cam = get_viewport().get_camera_2d()
			if cam:
				var t = create_tween()
				t.tween_property(cam, "zoom", Vector2(1.2, 1.2), 0.1)
				t.tween_property(cam, "zoom", Vector2(1, 1), 0.3).set_delay(0.5)

func start_glitch_loop() -> void:
	next_button.modulate.a = 1.0
	if glitch_loop: glitch_loop.kill()
	
	glitch_loop = create_tween().set_loops()
	glitch_loop.tween_callback(func():
		next_button.position = original_button_pos + Vector2(randf_range(-4, 4), randf_range(-4, 4))
		next_button.modulate = Color(5, 5, 5)
	).set_delay(0.05)
	
	glitch_loop.tween_callback(func():
		next_button.position = original_button_pos
		next_button.modulate = Color.WHITE
	).set_delay(randf_range(0.1, 0.4))

func apply_screen_shake(duration: float, intensity: float) -> void:
	if not world_node: return

	var shake_tween = create_tween()
	var original_pos = world_node.position
	
	for i in range(int(duration / 0.05)):
		var offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		shake_tween.tween_property(world_node, "position", original_pos + offset, 0.05)
	
	shake_tween.tween_property(world_node, "position", original_pos, 0.05)

func setup_choices() -> void:
	choice_button_1.text = "YES"
	
	# Reusing the glitch logic for choice button 2
	var choice_glitch = create_tween().set_loops()
	choice_glitch.tween_callback(func():
		choice_button_2.text = ["YES", "NO", "ERR", "NULL"].pick_random()
		choice_button_2.modulate = Color(8, 1, 1) # Overbright red
	).set_delay(0.1)
	
	choice_glitch.tween_callback(func():
		choice_button_2.text = "YES"
		choice_button_2.modulate = Color.WHITE
	).set_delay(0.4)
	
	# Store this so we can kill it when a choice is made
	active_tween = choice_glitch 

## --- Signals & Input ---

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		advance_dialogue()

func _on_next_button_pressed() -> void:
	advance_dialogue()

func _on_choice_1_pressed() -> void:
	current_line += 1
	show_dialogue()

func _on_choice_2_pressed() -> void:
	trigger_error_screen()

func trigger_error_screen() -> void:
	error_overlay.show()
	set_buttons_disabled(true)
	apply_screen_shake(0.6, 30.0)

func _on_go_back_button_pressed() -> void:
	error_overlay.hide()
	set_buttons_disabled(false)
	current_line += 1
	show_dialogue()

## --- Helpers ---

func set_buttons_disabled(val: bool) -> void:
	next_button.disabled = val
	choice_button_1.disabled = val
	choice_button_2.disabled = val

func _kill_active_tweens() -> void:
	if active_tween: active_tween.kill()
	if glitch_loop: glitch_loop.kill()
	next_button.position = original_button_pos
	next_button.modulate = Color.WHITE

func start_level_transition() -> void:
	set_buttons_disabled(true)
	var fade = create_tween()
	fade.tween_property(self, "modulate:a", 0.0, 1.0)
	fade.finished.connect(func(): get_tree().change_scene_to_file("res://levels/game_itself.tscn"))
