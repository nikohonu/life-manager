extends Button

onready var todo_view = $"../.."
onready var label = $"../Label"


func _ready():
	pass


func _on_Start_button_up():
	var selected = todo_view.get_item_selected()
	if selected:
		Root.start_interval(int(selected[0].get_text(0)))
