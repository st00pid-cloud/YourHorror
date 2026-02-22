extends Node3D

if Input.is_action_just_pressed("ui_cancel"): # Usually the Esc key
	get_tree().paused = true
	$OptionsUI.show()
