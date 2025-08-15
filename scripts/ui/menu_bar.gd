extends MenuBar

const CREATE_MOD_WINDOW := preload("res://scenes/create_mod.tscn")
const DELETE_MOD_WINDOW := preload("res://scenes/delete_mod.tscn")

var item_structure: Dictionary = {
	"separator": false,
	"name": "",
	"func": null
}

func _ready() -> void:
	# File
	add_item({  
		"name": "Create Mod",
		"func": _create_mod
	}, $File)

	add_item({  
		"name": "Delete Mod",
		"func": _delete_mod
	}, $File)

	add_item({  
		"separator": true
	}, $File)

	add_item({  
		"name": "Reload List",
		"func": _reload_list
	}, $File)

	# Edit
	add_item({  
		"name": "Change Mod Settings"
	}, $Edit)

	add_item({  
		"separator": true
	}, $Edit)

	add_item({  
		"name": "Change HLM2 Path",
		"func": _change_hlm2_path
	}, $Edit)

	add_item({  
		"name": "Change HLM2 Mods Path",
		"func": _change_hlm2_mods_path
	}, $Edit)

	add_item({  
		"name": "Change Mods Path",
		"func": _change_mods_path
	}, $Edit)


func add_item(from: Dictionary, to: MenuButton) -> void:
	var safe := item_structure.duplicate()
	from.merge(safe)

	var popup := to.get_popup()
	var id := popup.item_count

	if from["separator"]:
		popup.add_separator(from["name"], id)
		return

	popup.add_item(from["name"], id)

	if from["func"]:
		popup.id_pressed.connect(
			func(this_id): 
			if this_id == id: 
				from["func"].call()
		)


func _create_mod() -> void:
	var window := CREATE_MOD_WINDOW.instantiate()
	Scene.add(window)

func _delete_mod() -> void:
	var window := DELETE_MOD_WINDOW.instantiate()
	Scene.add(window)

func _reload_list() -> void:
	Manager.reload()
	Scene.current.reload_mods_tree()

func _change_hlm2_path() -> void:
	%HLMPathDialog.show()

func _change_hlm2_mods_path() -> void:
	%HLMModsPathDialog.show()

func _change_mods_path() -> void:
	%ModsPathDialog.show()

func _on_path_dialog_dir_selected(dir: String) -> void:
	Save.data["hlm2_dir"] = dir
	import_vanilla_music()
	Save.save()

func _on_hlm_mods_path_dialog_dir_selected(dir:String) -> void:
	Save.data["hlm2_mods_dir"] = dir

	Save.save()

func _on_mods_path_dialog_dir_selected(dir:String) -> void:
	Save.data["mods_dir"] = dir
	import_vanilla_music()

	Manager.reload()
	Scene.current.reload_mods_tree()

	Save.save()

func import_vanilla_music() -> void:
	var path = Save.data["hlm2_dir"] + "/" + Path.wad("hlm2_music_desktop")
	if FileAccess.file_exists(path) && Save.data["mods_dir"]:
		var music_bytes = FileAccess.get_file_as_bytes(path)

		var to_path = Save.data["mods_dir"] + Path.wad("vanilla_music")
		var vanilla_music := FileAccess.open(to_path, FileAccess.WRITE)
		vanilla_music.store_buffer(music_bytes)
