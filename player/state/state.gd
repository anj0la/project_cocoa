extends Node
class_name PlayerState

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transitioned)
			
	if initial_state:
		initial_state.enter()
		current_state = initial_state
		
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_child_transitioned(source_state: State, new_state_name: String) -> void:
	if source_state != current_state:
		print("Error changing state: " + source_state.name + ", currently in: " + new_state_name)
		return
		
	var new_state = states[new_state_name]
	if !new_state:
		print("New state is empty.")
		return
		
	if current_state:
		current_state.exit()
	
	new_state.enter()	
	current_state = new_state
	
		
