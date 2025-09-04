class_name YouAreSureDialog extends TempConfirmation

func _ready() -> void:
    title = "Are you sure?"
    ok_button_text = "Yes"
    cancel_button_text = "No"