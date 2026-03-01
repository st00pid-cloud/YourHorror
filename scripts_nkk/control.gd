extends Control

@onready var oscilloscope = $SubViewport/Line2D # Path to your line
@onready var audio_player = $AudioStreamPlayer

# We use Tweens to make the transitions smooth and "electrical"
var tween: Tween

func _ready():
	# Connect all buttons in the VBoxContainer automatically
	for button in $VBoxContainer.get_children():
		if button is Button:
			button.mouse_entered.connect(_on_button_hover)
			button.mouse_exited.connect(_on_button_exit)
			button.pressed.connect(_on_button_pressed)

func _on_button_hover():
	# Increase amplitude and speed: "System Excitation"
	if tween: tween.kill()
	tween = create_tween().set_parallel(true)
	tween.tween_property(oscilloscope, "amplitude", 150.0, 0.2)
	tween.tween_property(oscilloscope, "frequency", 15.0, 0.2)
	# Play a high-pitched charge sound

	audio_player.play()

func _on_button_exit():
	# Return to idle state
	if tween: tween.kill()
	tween = create_tween().set_parallel(true)
	tween.tween_property(oscilloscope, "amplitude", 50.0, 0.5)
	tween.tween_property(oscilloscope, "frequency", 5.0, 0.5)

func _on_button_pressed():
	# Trigger a "Short Circuit" visual effect
	_trigger_glitch_effect()
	# Play a heavy relay click
