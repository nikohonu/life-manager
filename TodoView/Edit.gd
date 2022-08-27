extends ToolButton

onready var add_edit_todo = load("res://TodoView/AddEditTodo.tscn")
onready var edit_todo = add_edit_todo.instance()
onready var todo_view_tab = $"../.."
onready var id = 0


func _ready():
	edit_todo.connect("confirmed", self, "_on_EditTodo_confirmed")
	add_child(edit_todo)


func _on_Edit_button_up():
	var selected = todo_view_tab.get_item_selected()
	if selected:
		var task = Root.get_task(int(selected[0].get_text(0)))
		id = task["id"]
		var due = todo_view_tab.get_due(id)
		var priority = todo_view_tab.get_priority(id)
		var recurrence = todo_view_tab.get_recurrence(id)
		edit_todo.clear()
		edit_todo.init_edit(task["name"], due, priority, recurrence)
		edit_todo.popup_centered()


func _on_EditTodo_confirmed(
	name: String, due: Dictionary, priority: String, recurrence: Dictionary
):
	todo_view_tab.update_todo(id, name, due, priority, recurrence)
