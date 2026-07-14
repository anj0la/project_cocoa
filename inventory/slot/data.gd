extends Resource
class_name SlotData

@export var index: int
@export var item: ItemData
@export var quantity: int = 0

func clear() -> void:
	quantity = 0
	item = null	
	
func is_empty() -> bool:
	return item == null
	
func is_same(other: SlotData) -> bool:
	if item.id == other.item.id:
		return true
		
	return false
	
func is_stackable() -> bool:
	return item.is_stackable
	
func can_merge_with(other: SlotData) -> bool:
	if is_empty() or other.is_empty():
		return false
	return item.id == other.item.id and item.is_stackable and \
	quantity + other.quantity <= item.max_stack

func merge_with(other: SlotData) -> void:
	if can_merge_with(other):
		var available_space = other.item.max_stack - other.quantity # same item == same max stack
		var transfer_amount = min(quantity, available_space)
		other.quantity += transfer_amount
		quantity -= transfer_amount
		
		if quantity <= 0: # source slot has fully merged with other slot (full merge)
			clear()
			
func copy() -> SlotData:
	var new_slot = SlotData.new()
	new_slot.index = index
	new_slot.item = item
	new_slot.quantity = quantity
	return new_slot
	
func copy_into(target: SlotData) -> void:
	target.index = index
	target.item = item
	target.quantity = quantity

static func from_item(item_data: ItemData, item_quantity: int, item_index: int) -> SlotData:
	var slot := SlotData.new()
	slot.item = item_data
	slot.quantity = item_quantity
	slot.index = item_index
	return slot

static func from_recipe(recipe: RecipeData, item_index: int) -> SlotData:
	return from_item(recipe.result_item, 1, item_index)
