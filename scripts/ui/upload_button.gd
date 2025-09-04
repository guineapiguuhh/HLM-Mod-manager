class_name UploadButton extends Button

signal file_selected(dialog, path)
signal files_selected(dialog, paths)

var CHECKMARK_TEXTURE = preload("res://images/checkmark.png")
var UPLOAD_TEXTURE = preload("res://images/upload.png")

@export var filters: PackedStringArray
@export_enum("File Mode Open File", "File Mode Open Files") var file_mode: int

@export var dialog_title: String

var content: Array[Variant] = []

func _ready() -> void:
	content = []
	update_appearance()

func update_appearance() -> void:
	icon = CHECKMARK_TEXTURE
	self_modulate.a = 1.0
	if content.is_empty():
		icon = UPLOAD_TEXTURE
		self_modulate.a = 0.5

func append_file(path):
	var file_name = path.get_slice("/", path.get_slice_count("/") - 1)
	var file_bytes := FileAccess.get_file_as_bytes(path)
	content.append([file_name, file_bytes])

func _pressed() -> void:
	content = []
	update_appearance()

	match file_mode:
		NativeFileDialog.FILE_MODE_OPEN_FILE:
			NativeDialogs.open_file_dialog(
				dialog_title,
				filters,
				func (dialog, path):
					file_selected.emit(dialog, path)
					append_file(path)
					update_appearance()
			)

		NativeFileDialog.FILE_MODE_OPEN_FILES:
			NativeDialogs.open_files_dialog(
				dialog_title,
				filters,
				func (dialog, paths):
					files_selected.emit(dialog, paths)
					for path in paths: append_file(path)
					update_appearance()
			)
			
		_: pass
