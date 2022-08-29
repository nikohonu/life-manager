extends ToolButton

onready var add_edit_todo = load("res://TodoView/AddEditTodo.tscn")
onready var add_todo = add_edit_todo.instance()
onready var tree = $"../../Tree"


func _ready():
	add_todo.connect("confirmed", self, "_on_AddTodo_confirmed")
	add_child(add_todo)


func _on_Add_button_up():
	add_todo.clear()
	add_todo.popup_centered()


func _on_AddTodo_confirmed(name: String, tags: PoolStringArray):
	Task.add_task(name, tags)
	tree.update_items()
