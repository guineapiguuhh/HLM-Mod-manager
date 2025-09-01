@tool
extends EditorPlugin

const MODULE_NAME = "NativeDialogs"
const MODULE_PATH = "native_dialogs.gd"

func _enter_tree() -> void: 
	add_autoload_singleton(MODULE_NAME, MODULE_PATH)

func _exit_tree() -> void: 
	remove_autoload_singleton(MODULE_NAME)
