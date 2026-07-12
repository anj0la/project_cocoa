extends CharacterBody3D
class_name Player

signal inventory_toggle

@export var inventory: InventoryData

func _on_ready() -> void:
	if not inventory: # only create new inventory on first instance
		inventory = InventoryData.new()
		inventory.max_slots = 32
		inventory.slots = []

		for i in range(inventory.max_slots):
			var slot = SlotData.new()
			slot.index = i
			inventory.slots.append(slot)
			
		print("player inventory: ", inventory)

func _on_detection_inventory_toggle() -> void:
	inventory_toggle.emit()
