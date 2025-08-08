extends Node

@onready var current: Node:
	set(value):
		current = value
		get_tree().current_scene = value
	get(): 
		return get_tree().current_scene

@onready var first: Node = current
var previous: Node

func change_to_file(path: String) -> int:
	return change_to_packed(load(path))
	
func change_to_packed(packed: PackedScene) -> int:
	var scene: Node = packed.instantiate()
	if not scene:
		return ERR_CANT_CREATE

	previous = current

	unload()
	get_tree().root.add_child(scene)
	current = get_tree().root.get_node(scene.get_path())

	return OK

func reload() -> int:
	var path := current.get_scene_file_path()
	return change_to_file(path)

func unload():
	current.free()

func get_mouse_pos() -> Vector2:
	return current.get_local_mouse_position()

func get_global_mouse_pos() -> Vector2:
	return DisplayServer.mouse_get_position() as Vector2

func add(node:Node, force_readable_name: bool = false, internal: int = 0) -> void:
	current.add_child(node, force_readable_name, internal)

func remove(node:Node) -> void:
	current.remove_child(node)
