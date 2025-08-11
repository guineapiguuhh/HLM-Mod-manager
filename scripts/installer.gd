extends Node

func install(config: Dictionary) -> void:
	add_patchwads(config)

	var music_path = Path.mods_folder + config["folder_name"] + "/" + Path.wad("music")
	var music_bytes = FileAccess.get_file_as_bytes(music_path)
	replace_music(music_bytes)

func uninstall(config: Dictionary) -> void:
	remove_patchwads(config)

	var music_path = Path.app_folder + Path.wad("vanilla_music")
	var music_bytes = FileAccess.get_file_as_bytes(music_path)
	replace_music(music_bytes)

func replace_music(bytes: PackedByteArray) -> void:
	var hlm2_music_path = Save.data["hlm2_dir"] + Path.wad("hlm2_music_desktop")
	var music_file := FileAccess.open(hlm2_music_path, FileAccess.WRITE_READ)
	music_file.store_buffer(bytes)

func add_patchwads(data: Dictionary) -> void:
	for patch in Manager.get_patchwads(data["folder_name"]):
		var patch_bytes = FileAccess.get_file_as_bytes(Path.mods_folder + data["folder_name"] + "/mods/" + patch)

		var patchwad := FileAccess.open(Path.hlm2_mods_folder + patch, FileAccess.WRITE)
		patchwad.store_buffer(patch_bytes)

func remove_patchwads(data: Dictionary) -> void:
	for patch in Manager.get_patchwads(data["folder_name"]):
		DirAccess.remove_absolute(Path.hlm2_mods_folder + patch)
