extends Control

# References to nodes based on your hierarchy
@onready var sfx_slider = $CanvasLayer/ColorRect/CenterContainer/VBoxContainer/SFX/HSlider

func _ready():
	# Make sure the UI starts hidden
	self.hide()
	# Set slider initial value to match current audio bus volume
	var bus_index = AudioServer.get_bus_index("Master") # Or "SFX" if you have one
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

# Triggered by 'PAUSE GAME' button (if used to pause initially)
func _on_pause_game_pressed():
	get_tree().paused = true
	self.show()

# Triggered by 'BACK TO GAME' button
func _on_back_to_game_pressed():
	get_tree().paused = false
	self.hide()

# Triggered by the HSlider inside the SFX GridContainer
func _on_h_slider_value_changed(value):
	var bus_index = AudioServer.get_bus_index("Master")
	# Convert 0.0-1.0 slider range to decibels
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

# Triggered by 'EXIT GAME' button
func _on_exit_game_pressed():
	get_tree().quit()
