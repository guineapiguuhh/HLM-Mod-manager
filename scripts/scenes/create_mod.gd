extends Window

func _on_save_pressed() -> void:
	var config := {
		"folder_name": $FolderName/LineEdit.text,
		"display_name": $DisplayName/LineEdit.text,
		"description": $Description/TextEdit.text,
		"global_patchwads": $GlobalPatchWads.button_pressed
	}
	
	var music_bytes: PackedByteArray
	var music: Array[Variant] = $MusicWad/Upload.content
	if !music.is_empty(): music_bytes = music.front().back()

	var image_bytes: PackedByteArray
	var image: Array[Variant] = $CoverImage/Upload.content
	if !image.is_empty(): image_bytes = image.front().back()

	Manager.create(
		config, 
		image_bytes,
		music_bytes, 
		$PatchWads/Upload.content
	)

	Scene.current.reload_mods_tree()
	
	_on_close_requested()

func _on_close_requested() -> void: 
	queue_free()
