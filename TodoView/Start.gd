extends Button

onready var tree = $"../../Tree"


func _on_Start_button_up():
	var selected = tree.get_item_selected()
	if selected:
		Interval.start_interval(int(selected[0].get_text(0)))
		tree.update_items()
