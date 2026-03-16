extends Node3D

@onready var player_inv: InventoryUI = $PlayerInventory
@onready var player: Player = $Player

func _ready():
	# Populate player inventory with saved (or new) data
	# print(player.inventory)
	player_inv.init_inventory(player.inventory)

func _on_player_inventory_toggle() -> void:
	if not player_inv.visible:
		player_inv.show()
	else:
		player_inv.hide()
	
	if player_inv.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.set_physics_process(false)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		player.set_physics_process(true)

func _on_square_item_collected(data: ItemData) -> void:
	player_inv.add_item_to_inventory(data)
