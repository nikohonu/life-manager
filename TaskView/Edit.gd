extends ToolButton

onready var edit_add_task = load("res://TaskView/EditAddTask.tscn")
onready var task_view = $"../.."
onready var root = $"../../../../.."
onready var id = 0

var edit_task: WindowDialog

func _ready():
	edit_task = edit_add_task.instance()
	edit_task.connect("confirmed", self, "_on_EditAddTask_confirmed")
	add_child(edit_task)

func _on_Edit_button_up():
	var selected = task_view.get_item_selected()
	if selected:
		var task = Root.get_task(int(selected[0].get_text(0)))
		id = task['id']
		edit_task.popup_centered()
		edit_task.clear()
		edit_task.init_edit(task['name'], task['tags'])

func _on_EditAddTask_confirmed(name: String, tags: PoolStringArray):
	if name != '':
		task_view.update_task(id, name, tags)
	task_view._update_tag(true)
