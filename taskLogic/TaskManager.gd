extends Node

signal task_completed(task_id)
signal task_added(task_data)

var active_tasks: Dictionary = {}
var completed_tasks: Array[String] = []

func add_task(task: TaskData):
	if not active_tasks.has(task.task_id):
		active_tasks[task.task_id] = task
		task_added.emit(task)
		print("New Task: ", task.task_name)

func complete_task(task_id: String):
	if active_tasks.has(task_id):
		var task = active_tasks[task_id]
		active_tasks.erase(task_id)
		completed_tasks.append(task_id)
		task_completed.emit(task_id)
		print("Task Finished: ", task.task_name)
