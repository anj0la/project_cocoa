extends Resource
class_name InventoryData

@export var slots: Array[SlotData]
@export var max_slots: int = 32

var filled_slots: int = 0

func get_slot_by(index: int) -> SlotData:
	var slot := slots[index]
	if slot:
		slots[index] = null
		# update inventory (signal either here OR in the ui section)
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
	
func add_item(slot_data: SlotData) -> void:
	var index := first_empty_slot()
	if index == -1:
		return # inventory is full
	else:
		slot_data.index = index
		slots[index] = slot_data
	
func remove_item(index) -> void:
	slots[index].clear()
	
func swap_slots(a: int, b: int) -> void:
	var temp := slots[a]
	slots[a] = slots[b]
	slots[b] = temp
