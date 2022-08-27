extends ToolButton

onready var add_edit_todo = load("res://TodoView/AddEditTodo.tscn")
onready var add_todo = add_edit_todo.instance()
onready var todo_view_tab = $"../.."


func _ready():
	add_todo.connect("confirmed", self, "_on_AddTodo_confirmed")
	add_child(add_todo)


func _on_Add_button_up():
	add_todo.clear()
	add_todo.popup_centered()


func _on_AddTodo_confirmed(name: String, due: Dictionary, priority: String, recurrence: Dictionary):
	todo_view_tab.add_todo(name, due, priority, recurrence)
