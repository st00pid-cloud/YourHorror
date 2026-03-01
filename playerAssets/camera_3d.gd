extends Camera3D # Or Node3D if attached to your Player

@onready var interact_ray = $RayCast3D
var current_interactable = null

func _process(_delta):
	_handle_interaction()

func _handle_interaction():
	if interact_ray.is_colliding():
		var detected_object = interact_ray.get_collider()
		print("Ray hit something: ", detected_object.name) # DEBUG 1
		
		if detected_object != current_interactable:
			_clear_current_interactable()
			
			if detected_object.has_method("_on_mouse_entered"):
				print("Object is interactable!") # DEBUG 2
				current_interactable = detected_object
				current_interactable._on_mouse_entered()
	else:
		_clear_current_interactable()

func _clear_current_interactable():
	if current_interactable:
		if current_interactable.has_method("_on_mouse_exited"):
			current_interactable._on_mouse_exited()
		current_interactable = null
