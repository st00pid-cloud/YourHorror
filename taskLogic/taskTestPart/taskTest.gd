extends Area2D

@export var task_resource: TaskManager

func _input_task_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if task_resource:
			TaskManager.show_task(task_resource)
