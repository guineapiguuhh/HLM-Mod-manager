extends Node

# ! Only support Windows

const PATCHWAD_EXT := ".patchwad"
const WAD_EXT := ".wad"

var my_games_folder := get_user_path() + "/Documents/My Games/"

var app_folder := my_games_folder + "HLM 2 Mod manager/"
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

func wad(path: String) -> String:
	return path + WAD_EXT

func patchwad(path: String) -> String:
	return path + PATCHWAD_EXT