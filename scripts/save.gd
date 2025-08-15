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
	if !FileAccess.file_exists(file_path): 
		data = init_data
		save()
		return
	
	var file := FileAccess.open(file_path, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())
	print(data)

func save() -> void:
	print(data)
	
	var new_data := JSON.stringify(data)
	var file := FileAccess.open(file_path, FileAccess.WRITE_READ)
	file.store_string(new_data)

func defined_dirs() -> bool:
	return data["hlm2_mods_dir"] && data["mods_dir"] && data["hlm2_dir"]