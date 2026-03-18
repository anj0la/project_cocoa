extends Resource
class_name ItemData

@export var id: int
@export var item_name: String
@export_multiline var description: String
@export var icon: AtlasTexture
@export var world_scene: PackedScene
@export var is_stackable: bool = true
@export var max_stack: int = 99
@export var tags: Dictionary = {
	"flavour": ["sweet", "creamy"],
	"quality_score": 1.0
}
@export var metadata: Dictionary = {} # Add affinity and contrast later
