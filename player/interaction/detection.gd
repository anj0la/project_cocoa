extends Area3D

@export var _camera: Camera3D

var _nearby_objects: Array[Node3D]
var _closest_object: Node3D = null
var _is_interacting: bool = false

func _process(_delta: float) -> void:
	if _closest_object:
		_update_prompt_orientation()

func _input(event: InputEvent) -> void:
	if _is_interacting:
		if event.is_action_pressed("interact") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			_closest_object.on_interact()
			#_nearby_objects.erase(_closest_object)
			#_closest_object = null
			_update_closest_object()

func _update_closest_object() -> void:
	if _nearby_objects.size() > 0:
		# Find the new closest object.
		_closest_object = _get_closest_object()
		
		# For respawnable objects (the object will be hidden, so we force focus
		
			
		if _closest_object.has_node("Interactable"):
			var interactable: Interactable = _closest_object.get_node("Interactable")
			interactable.gain_focus()
			_update_prompt_position()
			_is_interacting = true
			
		
			
		# Reset focus and run cleanup logic for all non-closest objects.
		for object in _nearby_objects:
			if object != _closest_object and object.has_node("Interactable"):
				var other: Interactable = object.get_node("Interactable")
				other.lose_focus()
				object.on_deinteract()
	else:
		# No nearby objects; reset closest_object.
		_closest_object = null
		_is_interacting = false
		
func _get_closest_object() -> Node3D:
	var closest = null
	var min_distance = INF
	for object in _nearby_objects:
		var distance = global_position.distance_to(object.global_position)
		if distance < min_distance:
			min_distance = distance
			closest = object
	return closest
	
func _update_prompt_position() -> void:
	if _closest_object:
		var interactable: Interactable = _closest_object.get_node("Interactable")
		var marker: Marker3D = _closest_object.get_node("PromptMarker")
		var prompt: Node3D = interactable.get_node("Prompt")
		interactable.prompt.visible = not _camera.is_position_behind(interactable.global_transform.origin)
		prompt.global_position = marker.global_position
		
func _update_prompt_orientation() -> void:
	if _closest_object:
		var interactable: Interactable = _closest_object.get_node("Interactable")
		var prompt: Node3D = interactable.get_node("Prompt")
		interactable.prompt.visible = not _camera.is_position_behind(interactable.global_transform.origin)
		var to_camera := Vector2(_camera.global_position.x - prompt.global_position.x, _camera.global_position.z - prompt.global_position.z)
		var right_axis: = Vector2(_closest_object.global_transform.basis.z.x, _closest_object.global_transform.basis.z.z)
		var side = to_camera.dot(right_axis)
		var sprite: Sprite3D = prompt.get_node("Sprite3D")
		sprite.flip_h = side < 0		
		
func _on_body_entered(body: Node3D) -> void:
	print("body entered: ", body.name)
	if body.has_node("Interactable"):
		_nearby_objects.append(body)
		_update_closest_object()
	
func _on_body_exited(body: Node3D) -> void:
	print("body exited: ", body.name)
	if body.has_node("Interactable") and _nearby_objects.has(body):
		var interactable: Interactable = body.get_node("Interactable")
		interactable.lose_focus()
		body.on_deinteract()

		# Remove the item from the nearby objects.
		var body_index = _nearby_objects.find(body)
		_nearby_objects.remove_at(body_index)
		_update_closest_object()	
