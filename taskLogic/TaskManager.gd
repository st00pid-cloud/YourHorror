extends Node

signal task_completed(task_id)
signal task_added(task_data)

var active_tasks: Dictionary = {}
var completed_tasks: Array[String] = []

# Reference to your Dialogue UI (Adjust the path to your actual UI node)
@onready var dialogue_label = get_node_or_null("/root/Main/UI/DialogueLabel")

func add_task(task: TaskData):
	if not active_tasks.has(task.task_id):
		active_tasks[task.task_id] = task
		task_added.emit(task)
		
		# Show dialogue when the task is assigned
		show_dialogue("New Objective: " + task.task_name)
		print("New Task: ", task.task_name)

func complete_task(task_id: String):
	if active_tasks.has(task_id):
		var task = active_tasks[task_id]
		active_tasks.erase(task_id)
		completed_tasks.append(task_id)
		task_completed.emit(task_id)
		
		# Show dialogue when the task is finished
		show_dialogue("Completed: " + task.task_name)
		print("Task Finished: ", task.task_name)

# The new function to handle the UI display
func show_dialogue(text: String):
	if dialogue_label:
		dialogue_label.text = text
		# Optional: Add a timer to clear the text after 3 seconds
		await get_tree().create_timer(3.0).timeout
		if dialogue_label.text == text:
			dialogue_label.text = ""
	else:
		print("Dialogue UI not found: ", text)
