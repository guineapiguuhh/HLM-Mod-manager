extends Node

var mods: Array[Dictionary] = []
var current: Dictionary

var global_patchwads: Array[String] = []

var structure_mod: Dictionary = {
	"display_name": "Mod",
	"description": "This mod is cool!!!",
}

func reload() -> void:
	mods = []
	global_patchwads = []

	for dir_name in DirAccess.get_directories_at(Path.mods_folder):
		var data_path := Path.mods_folder + dir_name + "/mod.json"

		if !FileAccess.file_exists(data_path): continue

		var base_data:FileAccess = FileAccess.open(data_path, FileAccess.READ)

		var data = JSON.parse_string(base_data.get_as_text())
		data["name"] = dir_name
		data["patchwads"] = get_patchwads(data["name"])

		if data["global_patchwads"]:
			global_patchwads.append_array(data["patchwads"])

		mods.append(data)
	
	print("Mods=" + str(mods))
	print("Global PatchWads=" + str(global_patchwads))
		
func apply(data: Dictionary=current) -> void:
	remove_all_patchwads()
	add_patchwads(data)

	var music_path = Path.mods_folder + data["name"] + "/" + Path.wad("hlm2_music_desktop")
	replace_music_wad(music_path)

func remove(data: Dictionary=current) -> void:
	remove_all_patchwads()
	remove_patchwads(data)

	var music_path = Path.app_folder + Path.wad("hlm2_music_desktop")
	replace_music_wad(music_path)

func replace_music_wad(path: String) -> void:
	if !FileAccess.file_exists(path): return
	
	var bytes:PackedByteArray = FileAccess.get_file_as_bytes(path)

	var music_wad := FileAccess.open(Save.data["hlm2_dir"] + Path.wad("hlm2_music_desktop"), FileAccess.WRITE_READ)
	music_wad.store_buffer(bytes)

func get_patchwads(mod_name: String) -> PackedStringArray:
	var path := Path.mods_folder + mod_name + "/mods/"
	if !DirAccess.dir_exists_absolute(path):
		return []
	return DirAccess.get_files_at(path)

func add_patchwads(data: Dictionary) -> void:
	for patch in get_patchwads(data["name"]):
		var patch_bytes = FileAccess.get_file_as_bytes(Path.mods_folder + data["name"] + "/mods/" + patch)

		var patchwad := FileAccess.open(Path.hlm2_mods_folder + patch, FileAccess.WRITE)
		patchwad.store_buffer(patch_bytes)

func remove_patchwads(data: Dictionary) -> void:
	for patch in get_patchwads(data["name"]):
		DirAccess.remove_absolute(Path.hlm2_mods_folder + patch)

func remove_all_patchwads() -> void:
	for patch in DirAccess.get_files_at(Path.hlm2_mods_folder):
		if global_patchwads.has(patch): continue
		DirAccess.remove_absolute(Path.hlm2_mods_folder + patch)
