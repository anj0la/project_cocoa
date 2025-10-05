extends MeshInstance3D
class_name Interactable

@export var _outline: MeshInstance3D
@onready var prompt: Control = $Prompt
@onready var label: Label = $Prompt/Panel/Label

var _camera: Camera3D

func _ready() -> void:
	_camera = get_viewport().get_camera_3d()

func _process(_delta: float) -> void:
	if _outline.visible:
		_update_ui_position()
		
func on_interact() -> void:
	_outline.hide()
	prompt.hide()
	
func on_deinteract() -> void:
	_outline.show()
	prompt.show()
	
func update_prompt(input: String):
	label.text = input
	
func _update_ui_position() -> void:
	prompt.visible = not _camera.is_position_behind(global_transform.origin)
	prompt.position = _camera.unproject_position(global_position)
