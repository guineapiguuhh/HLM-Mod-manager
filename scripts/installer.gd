extends Node

# TODO: More modular system!

func install(config: Dictionary) -> void:
	remove_patchwads()
	add_patchwads(config["folder_name"])

	var music_path = Path.mod(config["folder_name"]).path_join( Path.wad("music"))
	var music_bytes = FileAccess.get_file_as_bytes(music_path)
	replace_music(music_bytes)

func uninstall(config: Dictionary) -> void:
	remove_patchwads()
	remove_patchwads(config["folder_name"])

	var music_path = Save.data["mods_dir"].path_join(Path.wad("vanilla_music"))
	var music_bytes = FileAccess.get_file_as_bytes(music_path)
	replace_music(music_bytes)

func replace_music(bytes: PackedByteArray) -> void:
	var hlm2_music_path = Save.data["hlm2_dir"].path_join(Path.wad("hlm2_music_desktop"))
	var music_file := FileAccess.open(hlm2_music_path, FileAccess.WRITE_READ)
	music_file.store_buffer(bytes)

func import_vanilla_music() -> void:
	var path = Save.data["hlm2_dir"].path_join(Path.wad("hlm2_music_desktop"))
	if FileAccess.file_exists(path) && Save.data["mods_dir"]:
		var music_bytes = FileAccess.get_file_as_bytes(path)

		var to_path = Save.data["mods_dir"] + Path.wad("vanilla_music")
		var vanilla_music := FileAccess.open(to_path, FileAccess.WRITE)
		vanilla_music.store_buffer(music_bytes)

func add_patchwads(folder_name: String) -> void:
	for patch in Manager.get_patchwads(folder_name):
		var patch_bytes = FileAccess.get_file_as_bytes(
			Path.mod(folder_name)
			.path_join("mods")
			.path_join(patch)
		)

		var patchwad := FileAccess.open(Save.data["hlm2_mods_dir"].path_join(patch), FileAccess.WRITE)
		patchwad.store_buffer(patch_bytes)

func remove_patchwads(folder_name: String = '', force:bool = false) -> void:
	var vanilla_mods_dir = folder_name.is_empty()

	var content := Manager.get_patchwads(folder_name)
	if vanilla_mods_dir:
		content = DirAccess.get_files_at(Save.data["hlm2_mods_dir"])
		
	for patch in content:
		if vanilla_mods_dir && Manager.global_patchwads.has(patch) && !force:
			continue
		DirAccess.remove_absolute(Save.data["hlm2_mods_dir"].path_join(patch))
