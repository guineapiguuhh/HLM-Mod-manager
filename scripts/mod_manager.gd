extends Node

var mods: Array[Dictionary] = []
var current_mod: Dictionary

func _ready() -> void:
	update_mods()

func update_mods() -> void:
	mods = []

	for dir_name in DirAccess.get_directories_at(Path.mods_folder):
		var data_path := Path.mods_folder + dir_name + "/mod.json"

		if !FileAccess.file_exists(data_path): continue

		var base_data:FileAccess = FileAccess.open(data_path, FileAccess.READ)
		var parsed_data = JSON.parse_string(base_data.get_as_text())
		mods.push_front(parsed_data)
		
func apply_mod(data: Dictionary=current_mod) -> void:
	remove_patchwads()
	add_patchwads(data)

	var music_bytes = FileAccess.get_file_as_bytes(Path.mods_folder + data["name"] + "/" + Path.wad("hlm2_music_desktop"))
	replace_music_wad(music_bytes)

func remove_mod(_data: Dictionary=current_mod) -> void:
	remove_patchwads()

	var music_bytes = FileAccess.get_file_as_bytes(Path.mods_folder + Path.wad("hlm2_music_desktop"))
	replace_music_wad(music_bytes)

func replace_music_wad(bytes: PackedByteArray):
	var music := FileAccess.open(Save.data["hlm2_dir"] + "/" + Path.wad("hlm2_music_desktop"), FileAccess.WRITE_READ)
	music.store_buffer(bytes)

func add_patchwads(data: Dictionary) -> void:
	for patch in data["patchwads"]:
		var file_name = Path.patchwad(patch)

		var patch_bytes = FileAccess.get_file_as_bytes(Path.mods_folder + data["name"] + "/" + file_name)

		var patchwad := FileAccess.open(Path.hlm2_mods_folder + file_name, FileAccess.WRITE)
		patchwad.store_buffer(patch_bytes)

func remove_patchwads() -> void:
	for patch in DirAccess.get_files_at(Path.hlm2_mods_folder):
		if Save.data["global_patchwads"].has(patch): continue
		DirAccess.remove_absolute(Path.hlm2_mods_folder + patch)
