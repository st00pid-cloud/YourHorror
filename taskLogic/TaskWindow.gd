extends CanvasLayer

@onready var container = $VBoxContainer
@onready var task_label: Label = $ColorRect/VBoxContainer/Label
@onready var task_description: RichTextLabel = $ColorRect/VBoxContainer/RichTextLabel

var current_data: TaskData
var line_index: int = 0

func _ready():
	# Connect to the Global Manager signals
	TaskManager.task_added.connect(_on_task_added)
	TaskManager.task_completed.connect(_on_task_removed)

func _on_task_added(task: TaskData):
	var label = Label.new()
	label.name = task.task_id
	label.text = "[ ] " + task.task_name
	container.add_child(label)

func _on_task_removed(task_id: String):
	var label = container.get_node_or_null(task_id)
	if label:
		label.text = "[X] " + label.text.substr(4)
		# Optional: Fade out or remove after a delay
		var t = create_tween()
		t.tween_property(label, "modulate:a", 0, 2.0)
		t.finished.connect(label.queue_free)

func _display_line():
	if line_index >= current_data.lines.size():
		hide()
		return
	
	task_label.text = current_data.lines[line_index]
	task_label.visible_ratio = 0
	
	var tween = create_tween()
	tween.tween_property(task_label, "visible_ratio", 1.0, 1.0)
	line_index += 1

func show_task(data: TaskData):
	current_data = data
	line_index = 0
	task_label.text = data.task_name
	task_description.text = data.task_description
	
	show()
	_display_line()
