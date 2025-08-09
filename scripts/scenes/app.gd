extends Control

var root: TreeItem

func _ready() -> void:
	root = %Mods.create_item()
	
	for data in ModManager.mods:	
		var mod: TreeItem = %Mods.create_item(root)
		mod.set_text(0, data["name"])

		var json: TreeItem = %Mods.create_item(mod)
		json.set_text(0, str(data))
		json.visible = false

	%Mods.set_selected(root.get_child(0), 0)

func get_mod_data(item: TreeItem) -> Variant:
	var base_data = item.get_next_in_tree().get_text(0)
	return JSON.parse_string(base_data)

func _on_mods_item_selected() -> void:
	var data = get_mod_data(%Mods.get_selected())
	ModManager.current_mod = data
	%ModInfo.set_data()

func _on_hlm_2_path_dialog_dir_selected(dir: String) -> void:
	Path.hlm2_internal_path = dir
