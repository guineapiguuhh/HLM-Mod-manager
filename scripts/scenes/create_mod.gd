extends Window

var music: PackedByteArray
var patchwads: Array[Variant]
var cover_image: Image

func _on_save_pressed() -> void:
	var config := {
		"folder_name": $FolderName.text,
		"display_name": $Name.text,
		"description": $Description.text,
		"global_patchwads": $GlobalPatchWads.button_pressed
	}
	
	Manager.create(
		config, 
		music, 
		patchwads,
		cover_image
	)

	Manager.reload()
	Scene.current.reload_mods_tree()
	
	_on_close_requested()

func _on_patch_wads_pressed() -> void:
	$PatchWadsDialog.show()

func _on_music_wad_pressed() -> void:
	$MusicDialog.show()

func _on_upload_pressed() -> void:
	$CoverImageDialog.show()

func _on_patch_wads_dialog_files_selected(paths:PackedStringArray) -> void:
	patchwads = []

	for path in paths:
		var patchwad_name = path.get_slice("/", path.get_slice_count("/") - 1)
		var bytes := FileAccess.get_file_as_bytes(path)
		patchwads.append([patchwad_name, bytes])

func _on_music_dialog_file_selected(path:String) -> void:
	var bytes := FileAccess.get_file_as_bytes(path)
	music = bytes

func _on_cover_image_dialog_file_selected(path:String) -> void:
	cover_image = Image.load_from_file(path)

func _on_close_requested() -> void: 
	queue_free()



