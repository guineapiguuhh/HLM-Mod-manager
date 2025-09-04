extends MenuBar

const CREATE_MOD_WINDOW := preload("res://scenes/create_mod.tscn")

var item_structure: Dictionary = {
	"separator": false,
	"name": "",
	"func": null
}

@onready var mods: ModsTree = Scene.current.get_node("Split/Mods")

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
		"name": "Reset Save",
		"func": _reset_save
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
	var data = mods.get_data(mods.get_selected())
	var window := YouAreSureDialog.new()
	window.dialog_text = "Are you sure you want to delete "
	window.dialog_text += "%s (%s)?" % [data["display_name"], data["folder_name"]]
	window.dialog_autowrap = true
	window.confirmed.connect(
		func ():
			Manager.delete(data["folder_name"])
			mods.reload()
	)
	window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	Scene.add(window)
	window.show()

func _reload_list() -> void:
	Scene.current.get_node("Split/Mods").reload()

func _reset_save() -> void:
	var window := YouAreSureDialog.new()
	window.dialog_text = "Are you sure you want reset your Save"
	window.dialog_autowrap = true
	window.confirmed.connect(
		func ():
			Save.reset(true)
	)
	window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	Scene.add(window)
	window.show()

func _change_hlm2_path() -> void:
	NativeDialogs.open_dir_dialog(
		"Open Hotline Miami 2 Directory", 
		func (_dialogue, dir):
			Save.data["hlm2_dir"] = dir
			Installer.import_vanilla_music()
			Save.save()
	)

func _change_hlm2_mods_path() -> void:
	NativeDialogs.open_dir_dialog(
		"Open Hotline Miami 2 Mods Directory", 
		func (_dialogue, dir):
			Save.data["hlm2_mods_dir"] = dir

			Save.save()
	)

func _change_mods_path() -> void:
	NativeDialogs.open_dir_dialog(
		"Open a Directory", 
		func (_dialogue, dir):
			Save.data["mods_dir"] = dir
			Installer.import_vanilla_music()

			Scene.current.get_node("Split/Mods").reload()

			Save.save()
	)
