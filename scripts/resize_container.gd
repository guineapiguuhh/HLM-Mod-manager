extends HSplitContainer

func _ready() -> void:
	_size_changed()
	get_viewport().size_changed.connect(_size_changed)

func _size_changed():
	size = get_viewport_rect().size