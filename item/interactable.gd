extends MeshInstance3D
class_name Interactable

@export var _outline: MeshInstance3D
@onready var prompt: Node3D = $Prompt
@onready var label: Label = $Prompt/Sprite3D/SubViewport/Panel/Label

var _camera: Camera3D

func _ready() -> void:
	_camera = get_viewport().get_camera_3d()

func is_outline_visible() -> bool:
	return _outline.visible
		
func on_interact() -> void:
	_outline.hide()
	prompt.hide()
	
func on_deinteract() -> void:
	pass
	
func gain_focus() -> void:
	_outline.show()
	prompt.show()
	
	print("outline is shown: ", _outline.visible)
	
func lose_focus() -> void:
	_outline.hide()
	prompt.hide()
	
func update_prompt(input: String):
	label.text = input
