extends Node

var mod_structure: Dictionary = {
	"display_name": null,
	"description": "Hotline Miami 2 Mod.",
	"global_patchwads": false
}

var mods: Array[Dictionary] = []
var global_patchwads: Array[String] = []

func reload() -> void:
	mods = []
	global_patchwads = []

	if !Save.data["mods_dir"]: return

	for dir_name in DirAccess.get_directories_at(Save.data["mods_dir"]):
		var data_path := Path.mod(dir_name) + "/" + Path.json("settings")
		if !FileAccess.file_exists(data_path): continue

		var base_data:FileAccess = FileAccess.open(data_path, FileAccess.READ)

		var data = JSON.parse_string(base_data.get_as_text())
		data.merge(mod_structure)

		data["folder_name"] = dir_name
		if !data["display_name"]: data["display_name"] = data["folder_name"]

		data["patchwads"] = get_patchwads(data["folder_name"])
		if data["global_patchwads"]:
			global_patchwads.append_array(data["patchwads"])

		mods.append(data)
		
func create(
	config: Dictionary, 
	image: PackedByteArray,
	music_bytes: PackedByteArray, 
	patchwads: Array[Variant]
) -> void:
	config.merge(mod_structure)

	var path := Path.mod(config["folder_name"]) + "/"
	DirAccess.make_dir_absolute(path)
	DirAccess.make_dir_absolute(path + "mods/")

	var config_file := FileAccess.open(path + Path.json("settings"), FileAccess.WRITE)
	config_file.store_string(JSON.stringify(config))

	if !image.is_empty():
		var image_file := FileAccess.open(path + Path.png("cover"), FileAccess.WRITE)
		image_file.store_buffer(image)
		
	if !music_bytes.is_empty():
		var music_file := FileAccess.open(path + Path.wad("music"), FileAccess.WRITE)
		music_file.store_buffer(music_bytes)

	for patchwad: Array in patchwads:
		var patchwad_file := FileAccess.open(path + "mods/" + patchwad.front(), FileAccess.WRITE)
		patchwad_file.store_buffer(patchwad.back())
	

func delete(mod_name: String) -> void:
	Path.remove_dir(Path.mod(mod_name))

func get_patchwads(mod_name: String) -> PackedStringArray:
	var path := Path.mod(mod_name) + "/mods/"
	if !DirAccess.dir_exists_absolute(path):
		return []
	return DirAccess.get_files_at(path)
