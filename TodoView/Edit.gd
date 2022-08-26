extends ToolButton

onready var add_edit_todo = load("res://TodoView/AddEditTodo.tscn")
onready var add_todo = add_edit_todo.instance()
onready var todo_view_tab = $"../.."
onready var id = 0


func _ready():
	add_todo.connect("confirmed", self, "_on_AddTodo_confirmed")
	add_child(add_todo)


func _on_Edit_button_up():
	var selected = todo_view_tab.get_item_selected()
	if selected:
		var task = Root.get_task(int(selected[0].get_text(0)))
		id = task['id']
		add_todo.popup_centered()
		add_todo.clear()
		var data = todo_view_tab.get_data(task['tags'])
		add_todo.init_edit(task['name'], data['due'], data['time'], data['recurrence'])


func _on_AddTodo_confirmed(name: String, due: String, time: String, recurrence: String):
	todo_view_tab.update_todo(id, name, due, time, recurrence)
