extends HSplitContainer

onready var root = get_node("/root/Root")
onready var tasks = $VBoxContainer/Tasks
onready var root_task = tasks.create_item()

func _ready():
	tasks.set_column_title(0, 'ID')
	tasks.set_column_title(1, 'Name')
	tasks.set_column_expand(0, false)
	tasks.set_column_min_width(0, 100)
	

func load_task(task: Dictionary):
	var item = tasks.create_item(root_task)
	item.set_text(0, String(task['id']))
	item.set_text(1, task['name'])
	item.set_editable(1, true)
	
func add_task(name: String = ''):
	var task = root.add_task(name)
	var item = tasks.create_item(root_task)
	item.set_text(0, String(task['id']))
	item.set_text(1, task['name'])
	item.set_editable(1, true)
	tasks.set_column_min_width(0, 100)


func _on_Root_on_tasks_loaded():
	for task in root.tasks:
		load_task(task)


func _on_Add_button_up():
	add_task()


func _on_Edit_button_up():
	print(tasks.get_selected())
	print(tasks.get_selected().get_text(0))


func _on_Tasks_item_edited():
	var children = root_task.get_children()
	while true:
		if not children:
			break
		else:
			root.update_task_name(int(children.get_text(0)), children.get_text(1))
		children = children.get_next()


func _on_Delete_button_up():
	var items = []
	var selected = tasks.get_next_selected(null)
	while selected:
		items.append(selected)
		selected = tasks.get_next_selected(selected)
	while items:
		var item = items.pop_back()
		root.remove_task(int(item.get_text(0)))
		item.free()
		tasks.update()
		

func _on_Tasks_multi_selected(item, column, selected):
	var s = []
	var children = root_task.get_children()
	while true:
		if not children:
			break
		else:
			if children.is_selected(0) and not (children  in s):
				s.append(children)
		children = children.get_next()
	print(s)
