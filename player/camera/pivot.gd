extends Node3D

@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var min_vertical_angle: float = -PI / 2
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var max_vertical_angle: float = PI / 4
@export_range(0.0, 1.0, 0.1) var min_zoom: float = 0.5
@export_range(0.0, 10.0) var max_zoom: float = 7.0

@onready var _spring_arm : SpringArm3D = $SpringArm3D

var _mouse_delta: Vector2 = Vector2.ZERO

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(_delta: float) -> void:
	rotation.x -= _mouse_delta.y * mouse_sensitivity
	rotation.x = clampf(rotation.x, min_vertical_angle, max_vertical_angle)
		
	rotation.y += -_mouse_delta.x * mouse_sensitivity
	rotation.y = wrapf(rotation.y, 0.0, TAU)
		
	# Zoom in/out
	if Input.is_action_pressed("zoom_in"):
		_spring_arm.spring_length -= 1.0
		_spring_arm.spring_length = clampf(_spring_arm.spring_length, min_zoom, max_zoom)
	if Input.is_action_pressed("zoom_out"):
		_spring_arm.spring_length += 1.0
		_spring_arm.spring_length = clampf(_spring_arm.spring_length, min_zoom, max_zoom)
		
	# Reset mouse delta for next iteration	
	_mouse_delta = Vector2.ZERO
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_mouse_delta += event.relative
