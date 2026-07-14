extends Control
class_name SelectableGridUI

signal item_selected(index: int, slot_data: SlotData, source: Variant)
signal item_deselected(index: int, slot_data: SlotData, source: Variant)
signal focused(index: int)

@export var slot_scene: PackedScene
@onready var slot_grid: GridContainer = $PanelContainer/MarginContainer/GridContainer

var slot_views: Array[SlotView] = []
var sources: Array = [] # ItemData / RecipeData per index, parallel to slot_views

var selection_mode := SelectableGridEnums.SelectionMode.SINGLE
var selected_index: int = -1
var selected_indices := {}
var focused_pos: Vector2i = Vector2i.ZERO
var grid_size: Vector2i = Vector2i.ZERO

func init(items: Array, cols: int) -> void:
	grid_size = Vector2i(cols, ceili(float(len(items)) / cols))
	_build_views(items)

func replace_slot(index: int, new_data: SlotData) -> void:
	slot_views[index].set_data(new_data)
	
func _build_views(items: Array) -> void:
	for child in slot_grid.get_children():
		child.queue_free()
	slot_views.clear()
	sources.clear()

	for i in len(items):
		var slot_view: SlotView = slot_scene.instantiate()
		slot_grid.add_child(slot_view)

		var entry = items[i]
		if entry is SlotData:
			slot_view.set_data(entry)
			sources.append(entry.item)
		elif entry is RecipeData:
			slot_view.set_data(SlotData.from_recipe(entry, i))
			sources.append(entry)

		slot_views.append(slot_view)

func _input(event: InputEvent) -> void:
	var dir := Vector2i(Input.get_vector("navigate_left", "navigate_right", "navigate_up", "navigate_down"))
	if dir != Vector2i.ZERO:
		var old_index := _index_from_pos(focused_pos)
		focused_pos = (focused_pos + dir).clamp(Vector2i.ZERO, grid_size - Vector2i.ONE)
		var new_index := _index_from_pos(focused_pos)
		_update_highlight(old_index, new_index)
		focused.emit(new_index)
	elif event.is_action_pressed("select_confirm"):
		_select(_index_from_pos(focused_pos))
	elif event.is_action_pressed("select_cancel"):
		_deselect(_index_from_pos(focused_pos))

func _index_from_pos(pos: Vector2i) -> int:
	return pos.y * grid_size.x + pos.x

func _update_highlight(old_index: int, new_index: int) -> void:
	if old_index >= 0 and old_index < slot_views.size():
		slot_views[old_index].highlight(false)
	slot_views[new_index].highlight(true)

func _select(index: int) -> void:
	var slot_view := slot_views[index]
	if slot_view.slot_data.is_empty():
		return # nothing there to select          

	match selection_mode:
		SelectableGridEnums.SelectionMode.SINGLE:
			selected_index = index
		SelectableGridEnums.SelectionMode.MULTI:
			selected_indices[index] = true

	item_selected.emit(index, slot_view.slot_data, sources[index])

func _deselect(index: int) -> void:
	var slot_view := slot_views[index]
	if slot_view.slot_data.is_empty():
		return

	match selection_mode:
		SelectableGridEnums.SelectionMode.SINGLE:
			if selected_index == index:
				selected_index = -1
		SelectableGridEnums.SelectionMode.MULTI:
			selected_indices.erase(index)

	item_deselected.emit(index, slot_view.slot_data, sources[index])
