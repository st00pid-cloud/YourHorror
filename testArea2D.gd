extends Area2D

@export var dialogue_resource: DialogueData

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if dialogue_resource:
			DialogueManager.show_dialogue(dialogue_resource)
