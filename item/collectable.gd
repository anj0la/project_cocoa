extends Node

@export var data: ItemData
@export var _interactable: Interactable

func collect() -> ItemData:
	_interactable.hide() # hide the collected item before removing it from the scene
	return data

func collect_once() -> ItemData:
	_interactable.hide() # hide the collected item before removing it from the scene
	_interactable.queue_free()
	return data
