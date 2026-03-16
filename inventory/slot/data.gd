extends Resource
class_name SlotData

@export var index: int
@export var item: ItemData
@export var quantity: int = 0
@export var metadata: Dictionary

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
	new_slot.metadata = metadata.duplicate(true)
	return new_slot
	
func copy_into(target: SlotData) -> void:
	target.index = index
	target.item = item
	target.quantity = quantity
	target.metadata = metadata.duplicate(true)
