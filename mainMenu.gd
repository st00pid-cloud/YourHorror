extends Control

func _on_start_game_main():
	get_tree().change_scene_to_file("res://cutscenes/assets_cutsce/scenes/first_cutscene.tscn")

func show_menu_main():
	# Show both the container and the layer
	self.show()
	if has_node("CanvasLayer"):
		$CanvasLayer.show()
		
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func show_about_page():
	get_tree().change_scene_to_file("res://propsAssets/Game_UI/aboutpage.tscn")
func _on_exit_game_main():
	get_tree().quit()
