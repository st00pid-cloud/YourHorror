extends CanvasLayer

@onready var container: VBoxContainer = %VBoxContainer
# Using a Dictionary to track labels safely
var task_nodes: Dictionary = {}

func _ready():
	print("My children are: ", get_children())
	TaskManager.task_added.connect(_on_task_added)
	TaskManager.task_completed.connect(_on_task_removed)

func _on_task_added(task: TaskData):
	if task.task_id in task_nodes: return # Prevent duplicates
	
	var label = Label.new()
	label.text = "[ ] " + task.task_name
	container.add_child(label)
	task_nodes[task.task_id] = label

func _on_task_removed(task_id: String):
	var label = task_nodes.get(task_id)
	
	if is_instance_valid(label):
		label.text = "[X] " + label.text.substr(4)
		
		var t = create_tween()
		t.tween_property(label, "modulate:a", 0, 1.0)
		t.finished.connect(func(): 
			label.queue_free()
			task_nodes.erase(task_id)
	
)
