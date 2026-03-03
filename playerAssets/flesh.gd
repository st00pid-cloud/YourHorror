extends CharacterBody2D

# This allows you to drag and drop the .tres file in the Inspector
@export var dialogue_to_play: DialogueData 

func _on_interaction_area_body_entered(body):
	if body.is_in_group("Player"):
		DialogueManager.show_dialogue(dialogue_to_play)
