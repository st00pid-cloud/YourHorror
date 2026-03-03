extends CanvasLayer

# Update these paths to match your new tree!
@onready var name_label = $Control/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/NameLabel
@onready var text_label = $Control/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/TextLabel
@onready var portrait_sprite = $Control/PanelContainer/MarginContainer/HBoxContainer/Portrait

var current_data: DialogueData
var line_index: int = 0

func show_dialogue(data: DialogueData):
	current_data = data
	line_index = 0
	
	name_label.text = data.character_name
	portrait_sprite.texture = data.character_portrait
	
	show()
	_display_line()

func _display_line():
	if line_index >= current_data.lines.size():
		hide()
		return
	
	text_label.text = current_data.lines[line_index]
	text_label.visible_ratio = 0
	
	var tween = create_tween()
	tween.tween_property(text_label, "visible_ratio", 1.0, 1.0)
	line_index += 1

func _input(event):
	if is_visible() and event.is_action_pressed("ui_accept"):
		_display_line()
