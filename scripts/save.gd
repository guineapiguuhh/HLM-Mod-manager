extends Node

var file_name := Path.json("save")
var file_path := "user://" + file_name

var init_data := {
	"hlm2_dir": null,
	"hlm2_mods_dir": null,
	"mods_dir": null
}

var data := {}

func _ready() -> void:
	reset()

func reset(force:bool = false) -> void:
	if !FileAccess.file_exists(file_path) || force: 
		data = init_data
		save()
		return
	
	var file := FileAccess.open(file_path, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())

func save() -> void:
	var new_data := JSON.stringify(data)
	var file := FileAccess.open(file_path, FileAccess.WRITE_READ)
	file.store_string(new_data)

func is_defined_dirs() -> bool:
	return (data["hlm2_mods_dir"] 
		&& data["hlm2_dir"]
		&& data["mods_dir"]) 

func error_defined_dirs() -> void:
	var texts = []

	# TODO: Make this more smart??
	if !data["hlm2_mods_dir"]: texts.append("Edit > Change HLM2 Mods Path")
	if !data["hlm2_dir"]: texts.append("Edit > Change HLM2 Path")
	if !data["mods_dir"]: texts.append("Edit > Change Mods Path")

	NativeDialogs.open_accept_dialog(
		"Error",
		NativeAcceptDialog.Icon.ICON_ERROR,
		"Please define the paths.\n" + "\n".join(texts)
	)
