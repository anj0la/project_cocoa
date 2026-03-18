extends Resource
class_name RecipeData

@export var name: String
@export var category: RecipeEnums.Category
@export var required_ingredients: Array[ItemData]
@export var optional_ingredients: Array[ItemData]
@export var result_item: ItemData
@export var required_modifiers: Array[Dictionary] = [
	{RecipeEnums.Modifiers.TEMPER: 0},
	{RecipeEnums.Modifiers.CHILL: 0},
	{RecipeEnums.Modifiers.CARAMELIZE: 0},
	{RecipeEnums.Modifiers.AERATE: 0},
]
@export var tags: Dictionary = {
	"flavour": ["sweet", "creamy"],
	"style": ["classic", "nostalgic"],
	"quality_score": 1
}
@export var metadata: Dictionary = {
	"price_modifier": 1.0,
	"shelf_life": 15,
}
