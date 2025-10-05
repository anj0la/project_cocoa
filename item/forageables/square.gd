extends Node3D

signal item_collected(data: ItemData)

@onready var _interactable: Interactable = $Interactable
@onready var _collectable: Node = $Collectable
@onready var _respawnable: Node = $Respawnable

func _ready() -> void:
	_interactable.update_prompt("Press E to Collect")
	
func on_interact() -> void:
	_interactable.on_interact()
	
	var data: ItemData = _collectable.collect()
	_respawnable.start_respawn()
	item_collected.emit(data)
