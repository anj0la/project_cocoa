extends PanelContainer
class_name SlotUI

signal selected(index: int)
signal split_stack(index: int)
signal canceled(index: int)
signal hovered(index: int)
signal unhovered(index: int)

@export var slot_data: SlotData
var normal_style: StyleBoxFlat = preload("res://inventory/slot/normal_style.tres")
var highlight_style: StyleBoxFlat = preload("res://inventory/slot/highlight_style.tres")

@onready var quantity_label: Label = $MarginContainer/Label
@onready var item_rect: TextureRect = $MarginContainer/TextureRect
@onready var highlight_overlay: PanelContainer = $Highlight

func update_display() -> void:
	if not slot_data.is_empty(): 
		if slot_data.quantity > 1:
			item_rect.texture = slot_data.item.icon
			quantity_label.text = str(slot_data.quantity)
			item_rect.show()
			quantity_label.show()
		else:
			quantity_label.hide() # only 1 item exists, so we hide the quantity but NOT the rect
	else:
		item_rect.texture = null
		quantity_label.text = str(0)
		item_rect.hide()
		quantity_label.hide()
	
func set_data(slot: SlotData) -> void:
	slot_data = slot
	if slot_data.is_empty():
		item_rect.texture = null
		item_rect.hide()
		quantity_label.hide()
		tooltip_text = ""
		return
	
	item_rect.texture = slot_data.item.icon
	item_rect.show()
	quantity_label.text = str(slot_data.quantity)
	if slot_data.quantity > 1:
		quantity_label.show()
	else:
		quantity_label.hide()
	
	tooltip_text = slot_data.item.item_name + '\n' + slot_data.item.description
	update_display()

func highlight(on: bool) -> void:
	if on:
		add_theme_stylebox_override("panel", highlight_style)
	else:
		add_theme_stylebox_override("panel", normal_style)

func _on_mouse_entered() -> void:
	highlight(true)

func _on_mouse_exited() -> void:
	highlight(false)
	
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory_split"): # i.e., shift + left mouse click, Y on Switchh
		split_stack.emit(slot_data.index)
	elif event.is_action_pressed("inventory_select"): # i.e., left mouse click, A on Switch 
		selected.emit(slot_data.index)
	elif event.is_action_pressed("inventory_cancel"): # i.e., right mouse click, B on Switch
		canceled.emit(slot_data.index)
