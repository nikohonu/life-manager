extends Button

onready var todo_view = $"../.."


func _ready():
	pass


func _on_Done_button_up():
	var selected = todo_view.get_item_selected()
	if selected:
		todo_view.complete(int(selected[0].get_text(0)))
