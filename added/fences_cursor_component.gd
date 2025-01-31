class_name FencesCursorComponent
extends Node

@export var grass_tilemap_layer: TileMapLayer
@export var fences_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var terrain: int = 2

@onready var player: Player


var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float


func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.HammerBuild:
			get_cell_under_mouse()
			remove_fences_cell()
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.HammerBuild:
			get_cell_under_mouse()
			add_fences_cell()


func get_cell_under_mouse() -> void:
	mouse_position = grass_tilemap_layer.get_local_mouse_position()
	cell_position = grass_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = grass_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = grass_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)
	
	print("Mouse_position: ", mouse_position, " cell_position: ", cell_position, " cell_source_id: ", cell_source_id)
	print("Distance: ", distance)


func add_fences_cell() -> void:
	if !InventoryManager.inventory.has("log") or InventoryManager.inventory["log"] == 0:
		return
		
	if distance < 20.0 && cell_source_id != -1:
		fences_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, terrain, true)
		InventoryManager.remove_collectable("log")

func remove_fences_cell() -> void:
	if distance < 20.0:
		fences_tilemap_layer.set_cells_terrain_connect([cell_position], 0, -1, true)
		InventoryManager.add_collectable("log")
