extends CanvasLayer

@onready var container = $VBoxContainer

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
