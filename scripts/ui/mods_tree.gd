class_name ModsTree extends Tree

@onready var root: TreeItem = create_item()

signal mod_selected(config:Dictionary)

func _ready() -> void:
	item_selected.connect(
		func ():
			var data = get_data(get_selected())
			mod_selected.emit(data)
	)
	reload()

func reload() -> void:
	Manager.reload()
	clear()
	root = create_item()
	set_hide_root(true)

	for data in Manager.mods:	
		var item: TreeItem = create_item(root)
		item.set_text(0, data["display_name"])

		var json: TreeItem = create_item(item)
		json.set_text(0, str(data))
		json.visible = false

		set_selected(root.get_child(0), 0)
	
func get_data(item: TreeItem) -> Variant:
	var base_data = item.get_next_in_tree().get_text(0)
	return JSON.parse_string(base_data)
