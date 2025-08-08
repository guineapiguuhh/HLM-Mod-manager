extends Node

const PATCH_EXT := ".patchwad"
const MUSIC_EXT := ".wad"

var user_profile := OS.get_environment("USERPROFILE")
var my_games_path := user_profile + "/Documents/My Games/"

var mods_path := my_games_path + "HLM 2 Mod manager/mods/"
var hlm2_mods_path := my_games_path + "HotlineMiami2/mods/"

var hlm2_path := "C:/Users/dagui/Desktop/Master of orion 2 modded/Hotline Miami 2 - Wrong Number/"

var mods: Array[Dictionary] = []
var current_mod: Dictionary

func _ready() -> void:
	update_mods()

func update_mods() -> void:
	mods = []

	for dir_name in DirAccess.get_directories_at(mods_path):
		var data_path := mods_path + dir_name + "/mod.json"

		if not FileAccess.file_exists(data_path): continue

		var base_data:FileAccess = FileAccess.open(data_path, FileAccess.READ)
		var parsed_data = JSON.parse_string(base_data.get_as_text())
		mods.push_front(parsed_data)
		
func apply_mod(data: Dictionary=current_mod) -> void:
	var music_wad_name = "hlm2_music_desktop" + MUSIC_EXT
	for patch in data["patchwads"]:
		var file_name = patch + PATCH_EXT

		var patch_bytes = FileAccess.get_file_as_bytes(mods_path + data["name"] + "/" + file_name)

		var mod := FileAccess.open(hlm2_mods_path + file_name, FileAccess.WRITE)
		mod.store_buffer(patch_bytes)

	var music_bytes = FileAccess.get_file_as_bytes(mods_path + data["name"] + "/" + music_wad_name)

	var music := FileAccess.open(hlm2_path + music_wad_name, FileAccess.WRITE_READ)
	music.store_buffer(music_bytes)

func remove_mod(data: Dictionary=current_mod) -> void:
	var music_wad_name = "hlm2_music_desktop" + MUSIC_EXT
	for patch in data["patchwads"]:
		var file_name = patch + PATCH_EXT
		DirAccess.remove_absolute(hlm2_mods_path + file_name)

	var music_bytes = FileAccess.get_file_as_bytes(mods_path + "/" + music_wad_name)

	var music := FileAccess.open(hlm2_path + music_wad_name, FileAccess.WRITE_READ)
	music.store_buffer(music_bytes)
