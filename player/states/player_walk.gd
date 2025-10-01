extends State
class_name PlayerWalk

@export var player: CharacterBody3D
@export var move_speed: float

func enter() -> void:
	# play animation
	pass
	
func exit() -> void:
	# stop animation
	pass
	
func update(_delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right",  "move_forward", "move_backward")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() # transforms 2D input into 3D vector
	if direction:
		player.velocity.x = direction.x * move_speed
		player.velocity.z = direction.z * move_speed
		print("Player has moved in this direction: " + str(input_dir))
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, move_speed)
		player.velocity.z = move_toward(player.velocity.z, 0, move_speed)
		print("Player is moving from walk to idle.")
		transitioned.emit(self, "idle") # walk -> idle

	player.move_and_slide()
	
func physics_update(_delta: float) -> void:
	pass
