extends CanvasLayer

@onready var label = $Label
@onready var panel = $Panel

func _ready():
	panel.visible = false
	add_to_group("DialogueSystem")

func display_text(message: String):
	panel.visible = true
	label.text = "override text"
	
	# Simple typewriter effect
	for letter in message:
		label.text += letter
		await get_tree().create_timer(0.04).timeout
	
	await get_tree().create_timer(3.0).timeout
	panel.visible = false
