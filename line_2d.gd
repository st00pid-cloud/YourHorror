extends Line2D

var time = 0.0
var frequency = 5.0
var amplitude = 50.0
var speed = 10.0

func _process(delta):
	time += delta * speed
	clear_points()
	
	for x in range(0, 1200, 10): # Draw across the screen
		# Sine wave formula: y = sin(x * freq + time) * amp
		var y = sin((x * 0.01) * frequency + time) * amplitude
		add_point(Vector2(x, 540 + y)) # 540 is the vertical center
