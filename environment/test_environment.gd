extends Node3D

@onready var player_inv: InventoryUI = $UI/PlayerInventory
@onready var player: Player = $Player
@onready var mixing_station: StaticBody3D = $MixingStation
@onready var recipe_manager: RecipeSessionManager = $RecipeSessionManager

var water = preload("res://item/ingredients/water.tres")
var corn_syrup = preload("res://item/ingredients/corn_syrup.tres")
var sugar = preload("res://item/ingredients/sugar.tres")
var milk_powder = preload("res://item/ingredients/milk_powder.tres")
	
func _ready():
	# Populate player inventory with saved (or new) data
	# print(player.inventory)
	mixing_station.init_mixing_station(recipe_manager)
	player_inv.init_inventory(player.inventory)
	
# TODO: Delete this later, just to test that the sweetmaking session works
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.echo: # 'echo' prevents action on key repeat
			if event.keycode == KEY_1:
				recipe_manager.add_ingredient(water)
			if event.keycode == KEY_2:
				recipe_manager.add_ingredient(corn_syrup)
			if event.keycode == KEY_3:
				recipe_manager.add_ingredient(sugar)
			if event.keycode == KEY_4:
				recipe_manager.add_ingredient(milk_powder)
			if event.keycode == KEY_C:
				recipe_manager.apply_modifier("caramelize", 4)
			if event.keycode == KEY_X:
				recipe_manager.apply_modifier("chill", 5)
			if event.keycode == KEY_9:
				recipe_manager.add_decoration()
			if event.keycode == KEY_0:
				recipe_manager.add_boxing()
				

func _on_player_inventory_toggle() -> void:
	if not player_inv.visible:
		player_inv.show()
	else:
		player_inv.hide()
	
	if player_inv.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.set_physics_process(false)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		player.set_physics_process(true)

func _on_square_item_collected(data: ItemData) -> void:
	player_inv.add_item_to_inventory(data)
	
func _on_recipe_session_manager_ingredient_added(ingredient: ItemData, required: bool) -> void:
	print(ingredient.item_name)
	print("required: " + str(required))
	
func _on_recipe_session_manager_modifier_applied(modifier_type: String, player_value: int) -> void:
	print("modifier applied: " + modifier_type)
	print("player value : " + str(player_value))

func _on_recipe_session_manager_step_completed(step: RecipeEnums.Step) -> void:
	print("step moved to: " + str(step)) # 0 = INGREDIENT, 1 = MODIFIER, 2 = DECORATION, 3 = BOXING, 4 = DONEE

func _on_recipe_session_manager_session_started(recipe: RecipeData) -> void:
	print("session started with chosen recipe: " + recipe.name)

func _on_recipe_session_manager_recipe_finished(finished_confection: ItemData) -> void:
	player_inv.add_item_to_inventory(finished_confection)

func _on_recipe_session_manager_wrong_ingredient(ingredient: ItemData) -> void:
	print("wrong ingredient: " + ingredient.item_name)
