class_name TempConfirmation extends ConfirmationDialog

func _ready() -> void:
    close_requested.connect(_on_close_requested)
    confirmed.connect(_on_close_requested)
    canceled.connect(_on_close_requested)

func _on_close_requested() -> void:
    queue_free()