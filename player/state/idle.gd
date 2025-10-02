extends State
class_name PlayerIdle

func enter() -> void:
	# play animation
	pass
	
func exit() -> void:
	# stop animation
	pass
	
func update(_delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if input_dir:
		print("Player is moving from idle to walk.")
		transitioned.emit(self, "walk") # idle -> walk
