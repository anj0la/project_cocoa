extends Node

@export var respawn_time: float = 1.0
@export var _interactable: Interactable

var _timer: Timer

func _ready() -> void:
	_timer = Timer.new()
	add_child(_timer)  
	_timer.one_shot = true  
	_timer.timeout.connect(_on_respawn_timeout)

func start_respawn() -> void:
	if _interactable.visible:
		_interactable.hide() # hide the interactable before starting respawn process
	_timer.start(respawn_time)

func _on_respawn_timeout() -> void:
	_timer.stop()  # Stop the timer.
	_interactable.show()
	
