extends Node

func install(config: Dictionary) -> void:
	remove_all_patchwads()
	add_patchwads(config)

	var music_path = Path.mod(config["folder_name"]) + "/" + Path.wad("music")
	var music_bytes = FileAccess.get_file_as_bytes(music_path)
	replace_music(music_bytes)

func uninstall(config: Dictionary) -> void:
	remove_all_patchwads()
	remove_patchwads(config)

	var music_path = Save.data["mods_dir"] + "/" + Path.wad("vanilla_music")
	var music_bytes = FileAccess.get_file_as_bytes(music_path)
	replace_music(music_bytes)

func replace_music(bytes: PackedByteArray) -> void:
	var hlm2_music_path = Save.data["hlm2_dir"] + "/" + Path.wad("hlm2_music_desktop")
	var music_file := FileAccess.open(hlm2_music_path, FileAccess.WRITE_READ)
	music_file.store_buffer(bytes)

func add_patchwads(data: Dictionary) -> void:
	for patch in Manager.get_patchwads(data["folder_name"]):
		var patch_bytes = FileAccess.get_file_as_bytes(Path.mod(data["folder_name"]) + "/mods/" + patch)

		var patchwad := FileAccess.open(Save.data["hlm2_mods_dir"] + patch, FileAccess.WRITE)
		patchwad.store_buffer(patch_bytes)

func remove_patchwads(data: Dictionary) -> void:
	for patch in Manager.get_patchwads(data["folder_name"]):
		DirAccess.remove_absolute(Save.data["hlm2_mods_dir"] + patch)

func remove_all_patchwads() -> void:
	for file in DirAccess.get_directories_at(Save.data["mods_dir"]):
		if Manager.global_patchwads.has(file): continue
		DirAccess.remove_absolute(Save.data["hlm2_mods_dir"] + file)
