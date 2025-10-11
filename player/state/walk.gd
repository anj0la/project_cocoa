extends State
class_name PlayerWalk

@export var _player: CharacterBody3D
@export var _camera_pivot: Node3D
@export var move_speed: float

func enter() -> void:
	# play animation
	pass
	
func exit() -> void:
	# stop animation
	pass
	
func update(_delta: float) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right",  "move_forward", "move_backward")
	var direction := (_player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() # transforms 2D input into 3D vector
	if direction:
		var move_dir: Vector3 = Vector3.ZERO
		move_dir.x = direction.x
		move_dir.z = direction.z

		move_dir = move_dir.rotated(Vector3.UP, _camera_pivot.rotation.y).normalized()
		
		_player.velocity.x = move_dir.x * move_speed
		_player.velocity.z = move_dir.z * move_speed
		#print("Player has moved in this direction: " + str(input_dir))
	else:
		_player.velocity.x = move_toward(_player.velocity.x, 0, move_speed)
		_player.velocity.z = move_toward(_player.velocity.z, 0, move_speed)
		#print("Player is moving from walk to idle.")
		transitioned.emit(self, "idle") # walk -> idle

	_player.move_and_slide()
