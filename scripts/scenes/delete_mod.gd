extends Window

@onready var mods: Tree = Scene.current.get_node("HSplitContainer/ScrollContainer/Mods")
@onready var selected: TreeItem = mods.get_selected()
@onready var data = Scene.current.get_mod_data(selected)

func _ready() -> void:
	$Want.text += " " + data["display_name"] + " (" + data["folder_name"] + ")?";

func _process(_delta: float) -> void:
	$Want.size.x = size.x
	$Delete.position.x = (size.x - $Delete.size.x) / 2
	$Delete.position.y = size.y - $Delete.size.y - 10

func _on_delete_pressed() -> void:
	Manager.delete(data["folder_name"])
	Manager.reload()
	Scene.current.reload_mods_tree()

	_on_close_requested()

func _on_close_requested() -> void:
	queue_free()
