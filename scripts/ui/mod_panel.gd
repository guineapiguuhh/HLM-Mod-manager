class_name ModPanel extends PanelContainer

const ERROR_TEXTURE = preload("res://icon.png")
var mod: Dictionary

func _ready() -> void:
	queue_sort()
	resized.connect(func(): queue_sort())

func _on_apply_pressed() -> void:
	if !Save.is_defined_dirs():
		Save.error_defined_dirs()
		return

	Installer.install(mod)

func _on_remove_pressed() -> void:
	if !Save.is_defined_dirs():
		Save.error_defined_dirs()
		return

	Installer.uninstall(mod)

func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		$Name.position.y += $Cover.size.y * $Cover.scale.y + 25

		$Description.position.y = $Name.position.y
		$Description.position.y += $Name.size.y + 40
		$Description.size.x = size.x - 20

		$Buttons.position.y = $Description.position.y
		$Buttons.position.y += $Description.size.y + 80

		var children_rect := get_children_rect()
		for child: Control in get_children():
			child.position.x += (size.x - child.size.x * child.scale.x) / 2
			child.position.y += (size.y - children_rect.size.y) / 2
		
		$Cover.position.y = max($Cover.position.y, 0)
		$Buttons.position.y = min($Buttons.position.y, size.y - $Buttons.size.y * 1.65)

func get_children_rect() -> Rect2:
	var first_child = get_child(0)
	var final_child = get_child(get_child_count() - 1)

	var result := Rect2()
	result.position = first_child.position
	result.size.y = final_child.position.y + final_child.size.y
	result.size.x = 50

	return result

func set_mod(config: Dictionary) -> void:
	mod = config

	$Name.text = config["display_name"]
	$Description.text = config["description"]

	var image_path: String = Path.mod(config["folder_name"]) + "/cover.png"
	$Cover.texture = ERROR_TEXTURE
	if FileAccess.file_exists(image_path):
		var image := Image.load_from_file(image_path)
		$Cover.texture = ImageTexture.create_from_image(image)

	queue_sort()

func _on_mods_mod_selected(data:Dictionary) -> void:
	set_mod(data)
