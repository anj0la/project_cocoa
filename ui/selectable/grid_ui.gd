extends Control
class_name SelectableGridUI

signal selected
signal deselected
signal focused

@export var inventory: InventoryData 
@export var slot_scene: PackedScene

@onready var slot_grid: GridContainer = $PanelContainer/MarginContainer/GridContainer

var slot_view_ui: Array[SlotView] = []

var selection_mode = SelectableEnums.SelectionMode.SINGLE
var selected_index: int = -1  # SINGLE
var selected_indices := {}    # MULTI
var focused_index: int = 0

func init(items: Array) -> void:
	_build_views(items)
	_refresh_slots()
	
func _input(event: InputEvent) -> void:
	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if dir != Vector2i.ZERO:
		focused_pos = (focused_pos + dir).clamp(Vector2i.ZERO, grid_size - Vector2i.ONE)
		focused.emit(focused_pos)
	if event.is_action_pressed("ui_left"):
		focused_index -= 1
		focused.emit(focused_index)
	elif event.is_action_pressed("ui_right"):
		focused_index += 1
		focused.emit(focused_index)
	elif event.is_action_pressed("ui_up"):
		focused_index -= 1
		focused.emit(focused_index)
	if event.is_action_pressed("ui_down"):
		focused_index += 1
		focused.emit(focused_index)
	elif event.is_action_pressed("grid_accept"):
		selected.emit()
	elif event.is_action_pressed("grid_cancel"):
		deselected.emit()
		

	
	
func _build_views(items: Array) -> void:
	for i in len(items):
		var slot := SlotView.new()
		if items[i] is SlotData:
			slot.slot_data = items[i]
			slot.original_data = items[i].item
		elif items[i] is RecipeData:
			slot.slot_data = SlotData.new()
			slot.slot_data.item = items[i].result_item
			slot.slot_data.quantity = 1
			slot.slot_data.index = i
			slot.original_data = items[i]
			
		slot_view_ui.append(slot)
		slot.selected.connect(_on_slot_selected)
		slot.canceled.connect(_on_slot_canceled)
		
func _refresh_slots() -> void:
	for i in range(len(slot_grid.get_children())):
		var slot := slot_grid.get_child(i)
		slot.set_data(slot_view_ui[i].slot_data)

func _on_slot_selected(index: int) -> void:
	if not slot_view_ui[index].slot_data.is_empty():
		return
	
	var slot := slot_view_ui[index].slot_data
	# decrease quantity by 1 or decrease full quanitity?>
	# do something
	# slot.clear() # clears the quantity in this slot
		
	# Refresh the slots
	_refresh_slots()

func select(index: int):
	if selection_mode == SelectableEnums.SelectionMode.SINGLE:
		selected_index = index
	elif selection_mode == SelectableEnums.SelectionMode.MULTI:
		if index in selected_indices:
			return

		selected_indices[index] = true
