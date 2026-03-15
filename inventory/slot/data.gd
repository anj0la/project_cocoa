extends Resource
class_name SlotData

@export var index: int
@export var item: ItemData
@export var quantity: int = 1
@export var metadata: Dictionary

func is_empty() -> bool:
	return item == null and quantity <= 0
	
func clear() -> void:
	quantity = 0
	item = null
	
func is_stackable() -> bool:
	return item.is_stackable
	
func can_merge_with(other: SlotData) -> bool:
	return item.id == other.item.id and item.is_stackable and \
	(quantity + other.quantity < item.max_stack or other.quantity < item.max_stack)

func merge_with(other: SlotData) -> void:
	if can_merge_with(other):
		var available_space = other.max_stack - other.quantity # same item == same max stack
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
	new_slot.metadata = metadata
	return new_slot
