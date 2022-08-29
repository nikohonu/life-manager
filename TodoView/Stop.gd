extends Button

onready var tree = $"../../Tree"


func _on_Stop_button_up():
	Interval.stop_interval()
	tree.update_items()
