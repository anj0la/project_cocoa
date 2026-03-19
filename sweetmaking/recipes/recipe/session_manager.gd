extends Node
class_name RecipeSessionManager

# emitted when a new RecipeSession is created and ready
# UI and other systems know which recipe is active
signal session_started(recipe: RecipeData)

signal ingredient_added(ingredient: ItemData, required: bool)
signal wrong_ingredient(ingredient: ItemData)
signal modifier_applied(modifier_type: String, player_value: int)
signal step_completed(step: RecipeEnums.Step)
signal recipe_finished(finished_confection: ItemData)

var active_session: RecipeSession
var session_active: bool

func start_session(recipe: RecipeData) -> void:
	active_session = RecipeSession.new()
	active_session.init_session(recipe)
	active_session.ingredient_added.connect(_on_ingredient_added)
	active_session.wrong_ingredient.connect(_on_wrong_ingredient)
	active_session.modifier_applied.connect(_on_modifier_applied)
	active_session.step_completed.connect(_on_step_completed)
	active_session.recipe_finished.connect(_on_recipe_finished)
	
	session_started.emit(recipe)
	session_active = true
	
	print("recipe connected to active session: " + active_session.current_recipe.name)
	print("current step: " + str(active_session.current_step))
	print("session_active: " + str(session_active))
	
func add_ingredient(ingredient: ItemData) -> void:
	if session_active:
		active_session.add_ingredient(ingredient)

func apply_modifier(modifier_type: String, player_value: int) -> void:
	if session_active:
		active_session.apply_modifier(modifier_type, player_value)
		
func add_decoration() -> void:
	if session_active:
		active_session.add_decoration()
		
func add_boxing() -> void:
	if session_active:
		active_session.add_boxing()		
	
func clear_session() -> void:
	active_session = null
	session_active = false
	
func is_session_active() -> bool:
	return session_active
	
func _on_ingredient_added(ingredient: ItemData, required: bool) -> void:
	ingredient_added.emit(ingredient, required) # propagage signal further up
	
func _on_wrong_ingredient(ingredient: ItemData) -> void:
	wrong_ingredient.emit(ingredient) # propagage signal further up

func _on_modifier_applied(modifier_type: String, player_value: int) -> void:
	modifier_applied.emit(modifier_type, player_value) # propagage signal further up
	
func _on_step_completed(step: RecipeEnums.Step) -> void:
	step_completed.emit(step) # propagage signal further up
	
func _on_recipe_finished(finished_confection: ItemData) -> void:
	print("we have now finished the recipe")
	recipe_finished.emit(finished_confection)
	clear_session()
	
