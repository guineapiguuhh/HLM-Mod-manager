extends Node

# ! Only support Windows

const PATCHWAD_EXT := ".patchwad"
const WAD_EXT := ".wad"

var my_games_folder := get_user_path() + "/Documents/My Games/"

var app_folder := my_games_folder + "HLM Mod manager/"
var mods_folder := app_folder + "mods/"

var hlm2_folder := my_games_folder + "HotlineMiami2/"
var hlm2_mods_folder := hlm2_folder + "mods/"

func _ready() -> void:
	DirAccess.make_dir_absolute(app_folder)
	DirAccess.make_dir_absolute(mods_folder)

func get_user_path() -> String:
	var systems := {
		"Windows": OS.get_environment("USERPROFILE"),
		"macOS": OS.get_environment("USER"),
		"Linux": OS.get_environment("USER")
	}
	return systems[OS.get_name()]

func remove_dir(path: String) -> int:
	for file in DirAccess.get_files_at(path):
		DirAccess.remove_absolute(path.path_join(file))

	for directory in DirAccess.get_directories_at(path):
		remove_dir(path.path_join(directory))

	DirAccess.remove_absolute(path)

	return OK

func mod(mod_name: String) -> String:
	return mods_folder + mod_name

func json(path: String) -> String:
	return path + ".json"

func wad(path: String) -> String:
	return path + WAD_EXT

func patchwad(path: String) -> String:
	return path + PATCHWAD_EXT
