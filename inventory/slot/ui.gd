extends PanelContainer

signal pressed(slot_data: SlotData)
signal right_clicked(slot_data: SlotData)
signal drag_started(slot_data: SlotData)
signal drag_ended(slot_data: SlotData)
signal hovered(slot_data: SlotData)
signal unhovered(slot_data: SlotData)

@export var slot_data: SlotData

@onready var quantity_label: Label = $MarginContainer/Label
@onready var item_rect: TextureRect = $MarginContainer/TextureRect
@onready var highlight_overlay: PanelContainer = $Highlight

func update_display() -> void:
	if not slot_data.is_empty():
		item_rect.texture = slot_data.item.icon
		quantity_label.text = str(slot_data.quantity)
		item_rect.show()
		quantity_label.show()
	else:
		item_rect.texture = null
		quantity_label.text = str(0)
		item_rect.hide()
		quantity_label.hide()

func highlight(on: bool) -> void:
	if on:
		highlight_overlay.show()
	else:
		highlight_overlay.hide()

func _on_mouse_entered() -> void:
	highlight(true)
	hovered.emit(slot_data)

func _on_mouse_exited() -> void:
	highlight(false)
	unhovered.emit(slot_data)
	
func _on_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
