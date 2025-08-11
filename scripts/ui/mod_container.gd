class_name ModContainer extends PanelContainer

var mod: Dictionary

func _ready() -> void:
	resized.connect(func(): queue_sort())
	queue_sort()

func _on_apply_pressed() -> void:
	if !Save.data["hlm2_dir"]:
		%ErrorDialog.show()
		return

	Installer.install(mod)

func _on_remove_pressed() -> void:
	if !Save.data["hlm2_dir"]:
		%ErrorDialog.show()
		return

	Installer.uninstall(mod)

func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		$Name.position.y += $Cover.size.y + 25

		$Description.position.y = $Name.position.y
		$Description.position.y += $Name.size.y + 40
		$Description.size.x = size.x - 20

		$Buttons.position.y = $Description.position.y
		$Buttons.position.y += $Description.size.y + 80

		for child: Control in get_children():
			var rect := get_children_rect()
			child.position.x += (size.x - child.size.x) / 2
			child.position.y += (size.y - rect.size.y) / 2

func get_children_rect() -> Rect2:
	var first_child = get_child(0)
	var final_child = get_child(get_child_count() - 1)

	var result := Rect2()
	result.position = first_child.position
	result.size = final_child.position + final_child.size

	return result

func set_mod(config: Dictionary) -> void:
	mod = config

	$Name.text = config["display_name"]
	$Description.text = config["description"]
	#$Cover.texture = load(Path.mod(config["folder_name"]) + config["cover_image"])

	queue_sort()
