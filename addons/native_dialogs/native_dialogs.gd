extends Node

func _ready() -> void:
	pass

func open_accept_dialog(
	title: String, 
	icon: NativeAcceptDialog.Icon, 
	text: String, 
	on_confirmed: Callable = func(dialogue): pass
):
	var dialogue := NativeAcceptDialog.new()
	dialogue.title = title
	dialogue.dialog_text = text
	dialogue.dialog_icon = icon
	dialogue.confirmed.connect(
		func():
			on_confirmed.call(dialogue)
			Scene.remove(dialogue)
	)
	Scene.add(dialogue)

	dialogue.show()

func open_confirmation_dialog(
	title: String, 
	icon: NativeConfirmationDialog.Icon, 
	text: String, 
	on_confirmed: Callable = func(dialogue): pass,
	on_canceled: Callable = func(dialogue): pass
):
	var dialogue := NativeConfirmationDialog.new()
	dialogue.title = title
	dialogue.dialog_text = text
	dialogue.dialog_icon = icon
	dialogue.confirmed.connect(
		func():
			on_confirmed.call(dialogue)
			Scene.remove(dialogue)
	)
	dialogue.canceled.connect(
		func():
			on_canceled.call(dialogue)
			Scene.remove(dialogue)
	)
	Scene.add(dialogue)

	dialogue.show()

func open_dir_dialog(
	title: String = "Open Directory", 
	on_dir_selected: Callable = func(dialogue, dir): pass
):
	var dialogue := NativeFileDialog.new()
	dialogue.mode_overrides_title = false
	dialogue.title = title
	dialogue.file_mode = NativeFileDialog.FILE_MODE_OPEN_DIR
	dialogue.dir_selected.connect(
		func (dir: String):
			on_dir_selected.call(dialogue, dir)
	)
	dialogue.canceled.connect(
		func ():
			Scene.remove(dialogue)
	)
	Scene.add(dialogue)

	dialogue.show()

func open_file_dialog(
	title: String = "Open File", 
	filters: PackedStringArray = [],
	on_file_selected: Callable = func(dialogue, path): pass
):
	var dialogue := NativeFileDialog.new()
	dialogue.mode_overrides_title = false
	dialogue.title = title
	dialogue.file_mode = NativeFileDialog.FILE_MODE_OPEN_FILE
	dialogue.filters = filters
	dialogue.file_selected.connect(
		func (path: String):
			on_file_selected.call(dialogue, path)
	)
	dialogue.canceled.connect(
		func ():
			Scene.remove(dialogue)
	)
	Scene.add(dialogue)

	dialogue.show()

func open_files_dialog(
	title: String = "Open Files", 
	filters: PackedStringArray = [],
	on_files_selected: Callable = func(dialogue, paths): pass
):
	var dialogue := NativeFileDialog.new()
	dialogue.mode_overrides_title = false
	dialogue.title = title
	dialogue.file_mode = NativeFileDialog.FILE_MODE_OPEN_FILES
	dialogue.filters = filters
	dialogue.files_selected.connect(
		func (paths: PackedStringArray):
			on_files_selected.call(dialogue, paths)
	)
	dialogue.canceled.connect(
		func ():
			Scene.remove(dialogue)
	)
	Scene.add(dialogue)

	dialogue.show()
