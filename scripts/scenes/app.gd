extends Control

@onready var root: TreeItem = %Mods.create_item()

func _ready() -> void:
	reload_mods_tree()

func reload_mods_tree() -> void:
	Manager.reload()
	for item in root.get_children():
		item.free()

	for data in Manager.mods:	
		var mod: TreeItem = %Mods.create_item(root)
		mod.set_text(0, data["display_name"])

		var json: TreeItem = %Mods.create_item(mod)
		json.set_text(0, str(data))
		json.visible = false

		%Mods.set_selected(root.get_child(0), 0)

func get_mod_data(item: TreeItem) -> Variant:
	var base_data = item.get_next_in_tree().get_text(0)
	return JSON.parse_string(base_data)

func _on_mods_item_selected() -> void:
	var config = get_mod_data(%Mods.get_selected())
	%ModInfo.set_mod(config)
