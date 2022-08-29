extends ToolButton

onready var add_edit_todo = load("res://TodoView/AddEditTodo.tscn")
onready var edit_todo = add_edit_todo.instance()
onready var id = 0
onready var tree = $"../../Tree"


func _ready():
	edit_todo.connect("confirmed", self, "_on_EditTodo_confirmed")
	add_child(edit_todo)


func _on_Edit_button_up():
	var selected = tree.get_item_selected()
	if selected:
		id = int(selected[0].get_text(0))
		var task = Task.get_task(id)
		edit_todo.clear()
		edit_todo.init_edit(task)
		edit_todo.popup_centered()


func _on_EditTodo_confirmed(name: String, tags: PoolStringArray):
	Task.update_task(id, name, tags)
	tree.update_items()
