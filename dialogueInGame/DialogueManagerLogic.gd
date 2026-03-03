extends CanvasLayer
# Update these paths to match your new tree!
@onready var name_label: Label = $Node2D/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/Label
@onready var text_label: RichTextLabel = $Node2D/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/RichTextLabel
@onready var portrait_sprite: TextureRect = $Node2D/PanelContainer/MarginContainer/HBoxContainer/TextureRect

var current_data: DialogueData
var line_index: int = 0

func show_dialogue(data: DialogueData):
	current_data = data
	line_index = 0
	
	name_label.text = data.character_name
	portrait_sprite.texture = data.character_portrait
	
	show()
	_display_line()

# 1. NEW: Connect your Button's "pressed" signal to this function in the editor
func _on_next_button_pressed():
	if is_visible():
		_handle_progression()

func _display_line():
	if line_index >= current_data.lines.size():
		hide()
		return
	
	text_label.text = current_data.lines[line_index]
	text_label.visible_ratio = 0
	
	var tween = create_tween()
	tween.tween_property(text_label, "visible_ratio", 1.0, 1.0)
	line_index += 1

# 2. REFACTOR: Create a shared helper to prevent code duplication
func _handle_progression():
	if text_label.visible_ratio < 1.0:
		# If text is still typing, skip to the end of the line
		text_label.visible_ratio = 1.0
	else:
		# Otherwise, move to the next line
		_display_line()

func _input(event):
	if is_visible() and event.is_action_pressed("ui_accept"):
		_handle_progression()
