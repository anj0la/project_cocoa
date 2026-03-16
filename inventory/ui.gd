extends CanvasLayer
class_name InventoryUI

@export var inventory: InventoryData 
@export var slot_scene: PackedScene

@onready var slot_grid: GridContainer = $PanelContainer/MarginContainer/GridContainer
@onready var grabbed_slot: SlotUI = $GrabbedSlot

var held_slot_data: SlotData = null
var slot_ui_list: Array[SlotUI] = [] # logical display

func _process(delta: float) -> void:
	if grabbed_slot.visible:
		# mouse
		grabbed_slot.global_position = get_viewport().get_mouse_position()
		# joystick overrides if being used (Note: implement joystick
		#var stick = Input.get_vector("inventory_cursor_left", "inventory_cursor_right", "inventory_cursor_up", "inventory_cursor_down")
		#if stick.length() > 0.1:  # deadzone
			#grabbed_slot.global_position += stick * cursor_speed * delta

func init_inventory(inv: InventoryData) -> void:
	inventory = inv
	_build_slots()
	_refresh_slots()
	
func add_item_to_inventory(item_data: ItemData, count: int = 1) -> void:
	var slot := SlotData.new()
	slot.item = item_data
	inventory.add_item(slot, count)
	_refresh_slots()
	
func remove_item_from_inventory(index: int, count: int = 1) -> void:
	inventory.remove_item(index, count)
	_refresh_slots()
	
func split_stack_in_inventory(index: int, amount: int) -> void:
	inventory.split_stack(index, amount)
	_refresh_slots()
	
func swap_items(a: int, b: int) -> void:
	inventory.swap_slots(a, b)
	_refresh_slots()
	
func _build_slots() -> void:
	var inv_slots := inventory.slots
	for inv_slot in inv_slots:
		var slot := slot_scene.instantiate()		
		slot_grid.add_child(slot)
		slot.set_data(inv_slot)

		slot.selected.connect(_on_slot_selected)
		slot.split_stack.connect(_on_split_stack)
		slot.canceled.connect(_on_slot_canceled)
		#slot.hovered.connect(_on_slot_hovered)
		#slot.unhovered.connect(_on_slot_unhovered)

func _refresh_slots() -> void:
	for i in range(len(slot_grid.get_children())):
		var slot := slot_grid.get_child(i)
		slot.set_data(inventory.slots[i])

func _on_slot_selected(index: int) -> void:
	if not held_slot_data and inventory.slots[index].is_empty():
		return
	var slot := inventory.slots[index]
	if not held_slot_data:
		_pick_slot(inventory.slots[index])
	else: # currently "dragging" held slot data
		if slot.is_empty():
			_place_slot(index)
		else: # the slot is potentially stackable
			if slot.is_same(held_slot_data) and slot.is_stackable():
				_merge_slot(inventory.slots[index])
			else: # slot has a different item OR is not stackable, swap
				_swap_slot(inventory.slots[index])
				
	# Refresh the slots and update display
	_refresh_slots()
	_update_grabbed_slot_display() 
	
func _pick_slot(slot: SlotData) -> void:
	held_slot_data = slot.copy()
	slot.clear() # clears the quantity in this slot
		
func _place_slot(index: int) -> void:
	held_slot_data.index = index
	inventory.set_slot(held_slot_data, index)
	held_slot_data = null
	
func _merge_slot(slot: SlotData) -> void:
	slot.merge_with(held_slot_data)
	if held_slot_data.quantity <= 0:
		held_slot_data = null

func _swap_slot(slot: SlotData) -> void:
	var temp := slot.copy()
	inventory.set_slot(held_slot_data, slot.index)
	held_slot_data = temp
		
func _on_split_stack(index: int) -> void:
	var slot := inventory.slots[index]
	if slot.is_empty() or slot.quantity <= 1:
		return
		
	if not held_slot_data:
		held_slot_data = slot.copy()
		held_slot_data.quantity = 0
		
		var amount = floori(slot.quantity / 2.0)
		slot.quantity -= amount
		held_slot_data.quantity += amount
	else: # held slot data exists, check if holding same item
		if slot.is_same(held_slot_data):
			slot.quantity -= 1
			slot.quantity = max(slot.quantity, 1)
			
			held_slot_data.quantity += 1
	
	_refresh_slots()
	_update_grabbed_slot_display()

func _update_grabbed_slot_display() -> void:
	if held_slot_data:
		grabbed_slot.set_data(held_slot_data)
		grabbed_slot.show()
	else:
		grabbed_slot.hide()

func _on_slot_canceled(index) -> void:
	if held_slot_data:
		var slot := inventory.slots[index]
		if slot.is_empty():
			held_slot_data.index = index
			inventory.slots[index] = held_slot_data.copy()
			held_slot_data = null
		else:
			var i = inventory.first_empty_slot()
			if i == -1:
				return # the item is in HELD MODE still, either drop it in the world yourself or use the item to get it to go away
			held_slot_data.index = i 
			inventory.slots[i] = held_slot_data.copy()
			held_slot_data = null
			
	_refresh_slots()
	_update_grabbed_slot_display()
	
func _on_slot_hovered(index) -> void:
	inventory.slots[index].highlight(true)

func _on_slot_unhovered(index) -> void:
	inventory.slots[index].highlight(false)
