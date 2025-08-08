extends HSplitContainer

func _ready() -> void:
	get_viewport().size_changed.connect(_size_changed)

func _size_changed():
	size = get_viewport_rect().size