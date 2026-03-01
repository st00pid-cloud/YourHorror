extends Control

func _ready():
	# Hide the CanvasLayer or the ColorRect immediately on start
	$CanvasLayer.hide() 
	# Or, if the script is on the options node:
	hide()

func _input(event):
	if event.is_action_pressed("pause"):
		if self.visible:
			hide_menu()
		else:
			show_menu()
			
#ok na toh
func show_menu():
	# Show both the container and the layer
	self.show()
	if has_node("CanvasLayer"):
		$CanvasLayer.show()
		
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func hide_menu():
	self.hide()
	# Add this line to ensure the UI layer actually disappears
	if has_node("CanvasLayer"):
		$CanvasLayer.hide() 
	
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# --- Signal Connections ---

func _on_back_to_game_pressed():
	hide_menu()

func _on_exit_game_pressed():
	get_tree().quit()

func _on_menu_on_scene_pressed() -> void:
	show_menu()
	
