extends Node

var file_name := "save.json"
var file_path := "user://" + file_name

var init_data := {
	"hlm2_dir": null,
	"global_patchwads": []
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
