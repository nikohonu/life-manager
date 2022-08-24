extends Control

signal on_tasks_loaded

var tasks = []


func _load_tasks():
	var file = File.new()
	file.open("user://tasks.json", File.READ)
	tasks = parse_json(file.get_as_text())
	file.close()
	emit_signal("on_tasks_loaded")


func _save_tasks():
	var file = File.new()
	file.open("user://tasks.json", File.WRITE)
	file.store_string(to_json(tasks))
	file.close()


func _ready():
	_load_tasks()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_save_tasks()


func _get_new_id():
	var id = 0
	var ids = PoolIntArray()
	for task in tasks:
		ids.append(task['id'])
	while id in ids:
		id += 1
	return id


func get_task(id: int):
	for task in tasks:
		if task['id'] == id:
			return task
	return null


func _get_task_index(id: int):
	return tasks.find(get_task(id))


func add_task(name: String, tags: PoolStringArray = []):
	var task = {
		'id': _get_new_id(),
		'name': name,
		'tags': tags
	}
	tasks.append(task)
	return task
	

func is_namespace_tag(tag: String):
	return tag.find(':') != -1


func remove_task(id: int):
	tasks.remove(_get_task_index(id))


func update_task(id: int, name: String, tags: PoolStringArray = []):
	var task = get_task(id)
	task['name'] = name
	task['tags'] = tags
