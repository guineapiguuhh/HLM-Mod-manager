@tool
extends EditorPlugin

var utils:Dictionary[String, String] = {
	"Scene" = "utils/scene.gd"
}

func _enter_tree() -> void: 
	for util_name in utils:
		var scripts_path = utils[util_name]
		add_autoload_singleton(util_name, scripts_path)

func _exit_tree() -> void: 
	for util_name in utils:
		remove_autoload_singleton(util_name)
