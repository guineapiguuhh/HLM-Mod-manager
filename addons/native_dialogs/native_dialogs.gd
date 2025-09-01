extends Node

func _ready() -> void:
	pass

func open_accept_dialog(
	title: String, 
	icon: NativeAcceptDialog.Icon, 
	text: String, 
	on_confirmed: Callable = func(dialogue): pass
):
	var accept_dialogue := NativeAcceptDialog.new()
	accept_dialogue.title = title
	accept_dialogue.dialog_text = text
	accept_dialogue.dialog_icon = icon
	accept_dialogue.confirmed.connect(
		func():
			on_confirmed.call(accept_dialogue)
			Scene.remove(accept_dialogue)
	)
	Scene.add(accept_dialogue)

	accept_dialogue.show()

func open_dir_dialog(
	title: String = "Open Directory", 
	on_dir_selected: Callable = func(dialogue, dir): pass
):
	var dir_dialogue := NativeFileDialog.new()
	dir_dialogue.mode_overrides_title = false
	dir_dialogue.title = title
	dir_dialogue.file_mode = NativeFileDialog.FILE_MODE_OPEN_DIR
	dir_dialogue.dir_selected.connect(
		func (dir: String):
			on_dir_selected.call(dir_dialogue, dir)
	)
	dir_dialogue.canceled.connect(
		func ():
			Scene.remove(dir_dialogue)
	)
	Scene.add(dir_dialogue)

	dir_dialogue.show()

func open_file_dialog(
	title: String = "Open File", 
	filters: PackedStringArray = [],
	on_file_selected: Callable = func(dialogue, path): pass
):
	var file_dialogue := NativeFileDialog.new()
	file_dialogue.mode_overrides_title = false
	file_dialogue.title = title
	file_dialogue.file_mode = NativeFileDialog.FILE_MODE_OPEN_FILE
	file_dialogue.filters = filters
	file_dialogue.file_selected.connect(
		func (path: String):
			on_file_selected.call(file_dialogue, path)
	)
	file_dialogue.canceled.connect(
		func ():
			Scene.remove(file_dialogue)
	)
	Scene.add(file_dialogue)

	file_dialogue.show()

func open_files_dialog(
	title: String = "Open Files", 
	filters: PackedStringArray = [],
	on_files_selected: Callable = func(dialogue, paths): pass
):
	var files_dialogue := NativeFileDialog.new()
	files_dialogue.mode_overrides_title = false
	files_dialogue.title = title
	files_dialogue.file_mode = NativeFileDialog.FILE_MODE_OPEN_FILES
	files_dialogue.filters = filters
	files_dialogue.files_selected.connect(
		func (paths: PackedStringArray):
			on_files_selected.call(files_dialogue, paths)
	)
	files_dialogue.canceled.connect(
		func ():
			Scene.remove(files_dialogue)
	)
	Scene.add(files_dialogue)

	files_dialogue.show()
