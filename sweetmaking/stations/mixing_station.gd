extends StaticBody3D

@export var test_recipe: RecipeData
@onready var _interactable: Interactable = $Interactable
var _recipe_manager: RecipeSessionManager

func _ready() -> void:
	_interactable.update_prompt("Press E to Interact")

func init_mixing_station(manager: RecipeSessionManager):
	_recipe_manager = manager
		
func on_interact() -> void:
	_interactable.on_interact()
	_recipe_manager.start_session(test_recipe) # TODO: Change to a proper recipe selection
	print("started recipe: " + test_recipe.name) # For now, we'll just use a test recipe

func on_deinteract() -> void:
	pass
