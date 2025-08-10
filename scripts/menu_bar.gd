extends MenuBar

func _ready() -> void:
	$File.get_popup().id_pressed.connect(_file_pressed)
	$Edit.get_popup().id_pressed.connect(_edit_pressed)

func _file_pressed(id: int) -> void:
	match id:
		0:
			print("New mod...")
		1:
			ModManager.reload()
			Scene.current.reload_mods_tree()

func _edit_pressed(id: int) -> void:
	match id:
		0:
			print("Change mod data...")
		2:
			%PathDialog.show()

func _on_path_dialog_dir_selected(dir: String) -> void:
	Save.data["hlm2_dir"] = dir + "/"
	Save.save()
