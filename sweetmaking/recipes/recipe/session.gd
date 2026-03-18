extends Node
class_name RecipeSession

signal ingredient_added(ingredient: ItemData, required: bool)
signal wrong_ingredient(ingredient: ItemData)
signal modifier_applied(modifier_type: String, player_value: int)
signal step_completed(step: RecipeEnums.Step)
signal recipe_finished(finished_confection: ItemData)

var current_recipe: RecipeData
var current_step: RecipeEnums.Step
var ingredients_added: Array[ItemData]
var modifiers_added: Dictionary

var quality_score: float 

func init_session(recipe: RecipeData) -> void:
	current_recipe = recipe
	current_step = RecipeEnums.Step.INGREDIENT
	ingredients_added.clear()
	modifiers_added = _init_modifiers(recipe)
	quality_score = 1.0
	
# need to check that the ingredient added is a required or optional ingredient?
# think about it later
func add_ingredient(ingredient: ItemData) -> void:
	if current_step == RecipeEnums.Step.INGREDIENT:
		if _is_ingredient_required(ingredient):
			ingredients_added.append(ingredient)
			ingredient_added.emit(ingredient, true)
		elif _is_ingredient_optional(ingredient):
			quality_score *= 1.2
			ingredient_added.emit(ingredient, false)
		else:
			wrong_ingredient.emit(ingredient)

		if check_completion(): # if true, player has collected all required ingredients
			advance_step(RecipeEnums.Step.MODIFIER) # optional ingredients just increases quality,

func apply_modifier(modifier_type: String, player_value: int) -> void:
	if current_step == RecipeEnums.Step.MODIFIER:
		# for the prototype, we don't ALLOW the player to access modifiers that AREN'T
		# in the recipe (i.e., if the recipe doesn't have the chill modifier, the
		# fridge is NOT interactable / interaction is disabled)
		if _is_modifier_required(modifier_type):
			modifiers_added[modifier_type].result = player_value
			modifiers_added[modifier_type].completed = true
			
			# increase or decrease quality score based on correct modifier
			if modifiers_added[modifier_type].required == player_value:
				quality_score *= 1.2
			else:
				quality_score *= 0.9
				
		# check for completion
		if check_completion():
			advance_step(RecipeEnums.Step.DECORATION)

func add_decoration() -> void:
	print("add decoration steps post 0.1")
	advance_step(RecipeEnums.Step.BOXING)
	
func add_boxing() -> void:
	print("add boxing steps post 0.1")	
	advance_step(RecipeEnums.Step.DONE)
	
func advance_step(new_step: RecipeEnums.Step) -> void:
	current_step = new_step
	step_completed.emit(new_step)
	
func check_completion() -> bool:
	if current_step == RecipeEnums.Step.INGREDIENT:
		return _check_ingredient_completion()
	if current_step == RecipeEnums.Step.MODIFIER:
		return _check_modifier_completion()
	if current_step == RecipeEnums.Step.DECORATION:
		return _check_decoration_completion()
	if current_step == RecipeEnums.Step.BOXING:
		return _check_boxing_completion()	
	return false
	
func create_final_output() -> void:
	if current_step == RecipeEnums.Step.DONE:
		recipe_finished.emit(current_recipe.result_item)

func _init_modifiers(recipe: RecipeData) -> Dictionary:
	var modifiers = {}
	
	if recipe.required_modifiers["temper"] > 0:
		modifiers["temper"] = { "required": current_recipe.required_modifiers["temper"], 
		"result": null, "completed": false } 
	if recipe.required_modifiers["chill"] > 0:
		modifiers["chill"] = { "required": current_recipe.required_modifiers["chill"], 
		"result": null, "completed": false } 
	if recipe.required_modifiers["caramelize"] > 0:
		modifiers["caramelize"] = { "required": current_recipe.required_modifiers["caramelize"],
		 "result": null, "completed": false } 
	if recipe.required_modifiers["aerate"] > 0:
		modifiers["aerate"] = { "required": current_recipe.required_modifiers["aerate"], 
		"result": null, "completed": false } 
		
	return modifiers
	
func _is_ingredient_required(ingredient: ItemData) -> bool:
	if current_recipe.required_ingredients.has(ingredient):
		return true
	return false
	
func _is_ingredient_optional(ingredient: ItemData) -> bool:
	if current_recipe.optional_ingredients.has(ingredient):
		return true
	return false
	
func _check_ingredient_completion() -> bool:
	for ingredient in current_recipe.required_ingredients:
		if not ingredients_added.has(ingredient):
			return false
			
	return true
	
func _is_modifier_required(modifier_type: String) -> bool:
	return modifier_type in current_recipe.required_modifiers
	
func _check_modifier_completion() -> bool:
	for modifier in modifiers_added:
		if modifiers_added[modifier].completed == false:
			return false
	return true

# TODO: Create decoration step
func _check_decoration_completion() -> bool:
	return true
	
# TODO: Create boxing step
func _check_boxing_completion() -> bool:
	return true
