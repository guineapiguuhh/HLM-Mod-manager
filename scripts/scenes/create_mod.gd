extends Window

var music: PackedByteArray
var patchwads: Array[Variant]

func _on_save_pressed() -> void:
	var config := {
		"folder_name": $FolderName.text,
		"display_name": $Name.text,
		"description": $Description.text,
		"global_patchwads": $GlobalPatchWads.button_pressed
	}
	
	Manager.create(config, music, patchwads)
	Manager.reload()
	Scene.current.reload_mods_tree()
	
	_on_close_requested()

func _on_patch_wads_pressed() -> void:
	$PatchWadsDialog.show()

func _on_music_wad_pressed() -> void:
	$MusicDialog.show()

func _on_patch_wads_dialog_files_selected(paths:PackedStringArray) -> void:
	patchwads = []

	for path in paths:
		var patchwad_name = path.get_slice("/", path.get_slice_count("/") - 1)
		var bytes := FileAccess.get_file_as_bytes(path)
		patchwads.append([patchwad_name, bytes])

func _on_music_dialog_file_selected(path:String) -> void:
	var bytes := FileAccess.get_file_as_bytes(path)
	music = bytes

func _on_close_requested() -> void: 
	queue_free()
