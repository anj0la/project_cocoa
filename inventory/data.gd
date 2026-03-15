extends Resource
class_name InventoryData

@export var slots: Array[SlotData]
@export var max_slots: int = 32

func get_slot_by(index: int) -> SlotData:
	var slot := slots[index]
	if slot:
		slots[index] = null
		return slot
		
	return null # slot index not currently in the inventory
	
func set_slot(new_slot_data: SlotData, index: int) -> void:
	new_slot_data.index = index
	slots[index] = new_slot_data
	
func first_empty_slot() -> int:
	for i in range(max_slots):
		if slots[i].is_empty():
			return i
	
	return -1 # only happens if inventory is full
	
func fill_partial_slots(slot_data: SlotData) -> void:
	# quick check if item is stackable
	# if item is not stackable, function runs in O(1) time
	if not slot_data.is_stackable():
		return
	
	for i in range(max_slots):
		slots[i].merge_with(slot_data) # checks if item is stackable
		if slot_data.quantity == 0:
			return # finished early
			
func add_item(slot_data: SlotData, count: int = 1) -> void:
	slot_data.quantity = count
	fill_partial_slots(slot_data)
	
	# check if quantity is at 0 (if so, no more slots to fill)
	if slot_data.quantity <= 0:
		return # filled partial slots

	var index := first_empty_slot()
	if index == -1:
		return # inventory is full
	else:
		slot_data.index = index
		slots[index] = slot_data
	
func remove_item(index: int, count: int = 1) -> void:
	if slots[index].is_empty():
		return
		
	slots[index].quantity = slots[index].quantity - count
	if slots[index].quantity <= 0:
		slots[index].clear()
		
func split_stack(index: int, amount: int) -> void:
	var slot := slots[index]
	
	if slot.is_empty() or slot.quantity >= amount:
		return # if empty or the quantity is more than the amount, stack can't be split
		
	var new_slot := slot.copy() # copies info from slot to new one
	
	new_slot.quantity = amount
	slot.quantity -= amount
	
	if slot.quantity <= 0: # effectively "moved" the slot data to another position
		slot.clear()
		
	slots[first_empty_slot()] = new_slot
	
	
func swap_slots(a: int, b: int) -> void:
	var temp := slots[a]
	slots[a] = slots[b]
	slots[b] = temp
