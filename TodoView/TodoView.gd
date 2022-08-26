extends VBoxContainer


export var period: String


onready var tree = $Todo
onready var root_item = tree.create_item()


func get_item_selected() -> Array:
	var item = tree.get_next_selected(null)
	var selected = []
	while item:
		selected.append(item)
		item = tree.get_next_selected(item)
	return selected


func get_item_children(item: TreeItem) -> Array:
	item = item.get_children()
	var children = []
	while item:
		children.append(item)
		item = item.get_next()
	return children


func get_data(tags: PoolStringArray):
	var data = {'due': '', 'time': '', 'recurrence': ''}
	for tag in tags:
		for key in data:
			if tag.begins_with(key + ':'):
				data[key] =  tag.right(len(key)+1)
	return data


func _update():
	for item in get_item_children(root_item):
		item.free()
		tree.update()
	Root.tasks.sort_custom(self, 'todo_comparison')
	for task in Root.tasks:
		var item = tree.create_item(root_item)
		var data = get_data(task['tags'])
		item.set_text(0, String(task['id']))
		item.set_text(1, task['name'])
		item.set_text(3, data['due'])
		item.set_text(4, data['time'])
		item.set_text(5, data['recurrence'])
		for i in range(3, 6):
			item.set_text_align(i, ALIGN_END)


func todo_comparison(task_a, task_b):
	var data_a = get_data(task_a['tags'])
	var data_b = get_data(task_b['tags'])

	if data_a['due'] == data_b['due']:
		if not data_a['time']:
			return false
		if not data_b['time']:
			return true
		return data_a['time'] < data_b['time']
	if not data_a['due']:
		return false
	if not data_b['due']:
		return true
	return data_a['due'] < data_b['due']

func _ready():
	tree.set_column_title(0, 'ID')
	tree.set_column_expand(0, false)
	tree.set_column_min_width(0, 90)
	tree.set_column_title(1, 'Names')
	tree.set_column_min_width(0, 100)
	tree.set_column_title(2, 'Status')
	tree.set_column_min_width(2, 90)
	tree.set_column_expand(2, false)	
	tree.set_column_title(3, 'Due')
	tree.set_column_expand(3, false)
	tree.set_column_min_width(3, 90)
	tree.set_column_title(4, 'Time')
	tree.set_column_expand(4, false)
	tree.set_column_min_width(4, 90)
	tree.set_column_title(5, 'Recurrence')
	tree.set_column_expand(5, false)

	tree.set_column_min_width(5, 90)
	_update()


func add_todo(name: String, due: String, time: String, recurrence: String):
	var tags = ['due:' + due, 'time:' + time, 'recurrence:' + recurrence]
	Root.add_task(name, tags)
	_update()
	
func update_todo(id, name: String, due: String, time: String, recurrence: String):
	var tags = ['due:' + due, 'time:' + time, 'recurrence:' + recurrence]
	Root.update_task(id, name, tags)
	_update()


func _on_Edit_button_up():
	pass # Replace with function body.
