class_name ModContainer extends PanelContainer

@export var text_distance: float:
	set(value):
		text_distance = value
		queue_sort()

@export_subgroup("Theme Overrides")

@export var margin_left: float:
	set(value):
		margin_left = value
		queue_sort()

@export var margin_right: float:
	set(value):
		margin_right = value
		queue_sort()

@export var margin_top: float:
	set(value):
		margin_top = value
		queue_sort()

@export var margin_bottom: float:
	set(value):
		margin_bottom = value
		queue_sort()

func _ready() -> void:
	$Buttons/Apply.pressed.connect(_apply_pressed_mod);
	$Buttons/Remove.pressed.connect(_remove_pressed_mod);
	queue_sort()
	
func _apply_pressed_mod(): 
	if !Save.data["hlm2_dir"]:
		%ErrorPopup.show()
		return

	ModManager.apply_mod()

func _remove_pressed_mod(): 
	if !Save.data["hlm2_dir"]:
		%ErrorPopup.show()
		return
		
	ModManager.remove_mod()

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		var margin: Rect2 = Rect2()
		margin.position = Vector2(margin_right, margin_bottom)
		margin.size = Vector2(margin_left, margin_top)

		var preview_rect: Rect2 = $ModPreview.get_rect()
		preview_rect.position = margin.position
		fit_child_in_rect($ModPreview, preview_rect)

		$ModName.position.x += $ModPreview.size.x + text_distance

		$ModDescription.position.x += $ModPreview.size.x + text_distance
		$ModDescription.position.y += $ModName.size.y

		custom_minimum_size = get_biggest_size(get_children())


func get_biggest_size(nodes: Array[Node]) -> Vector2:
	var result := Vector2.ZERO
	for node: Control  in nodes:
		var total: Vector2 = node.position + node.size

		if total.x > result.x: result.x = total.x
		if total.y > result.y: result.y = total.y
	
	return result


func set_data(data: Dictionary=ModManager.current_mod) -> void:
	# $ModPreview.texture = # TODO: load image

	$ModName.text = data["name"]
	$ModDescription.text = data["description"]
	queue_sort()
