extends Camera3D

@export var _spring_arm : SpringArm3D
@export var lerp_power : float = 1.0

func _process(delta: float) -> void:
	position = lerp(position, _spring_arm.position, lerp_power * delta)
