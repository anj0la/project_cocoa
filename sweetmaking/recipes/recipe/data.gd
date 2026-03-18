extends Resource
class_name RecipeData

@export var name: String
@export var category: RecipeEnums.Category
@export var required_ingredients: Array[ItemData]
@export var optional_ingredients: Array[ItemData]
@export var result_item: ItemData
@export var required_modifiers: Dictionary = {
	"temper": 0,
	"chill": 0,
	"caramelize": 0,
	"aerate": 0,
}
@export var tags: Dictionary = {
	"flavour": ["sweet", "creamy"],
	"style": ["classic", "nostalgic"],
	"quality_score": 1.0
}
@export var metadata: Dictionary = {
	"price_modifier": 1.0,
	"shelf_life": 15,
}
