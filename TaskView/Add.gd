extends ToolButton

onready var edit_add_task = load("res://TaskView/EditAddTask.tscn")
onready var task_view = $"../.."

var add_task: WindowDialog


func _ready():
	add_task = edit_add_task.instance()
	add_task.connect("confirmed", self, "_on_EditAddTask_confirmed")
	add_child(add_task)


func _on_Add_button_up():
	add_task.popup_centered()
	add_task.clear()


func _on_EditAddTask_confirmed(name: String, tags: PoolStringArray):
	if name != "":
		task_view.add_task(name, tags)
