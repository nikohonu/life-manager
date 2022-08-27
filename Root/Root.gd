extends Node

var tasks = []
var intervals = []


func _load():
	var task_file = File.new()
	var interval_file = File.new()
	task_file.open("user://tasks.json", File.READ)
	interval_file.open("user://intervals.json", File.READ)
	tasks = parse_json(task_file.get_as_text())
	intervals = parse_json(interval_file.get_as_text())
	task_file.close()
	interval_file.close()


func _save():
	var task_file = File.new()
	var interval_file = File.new()
	task_file.open("user://tasks.json", File.WRITE)
	interval_file.open("user://intervals.json", File.WRITE)
	task_file.store_string(to_json(tasks))
	interval_file.store_string(to_json(intervals))
	task_file.close()
	interval_file.close()


func _ready():
	_load()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_save()


func _gen_id():
	var id = 0
	var ids = PoolIntArray()
	for task in tasks:
		ids.append(task["id"])
	while id in ids:
		id += 1
	return id


func add_task(name: String, tags: PoolStringArray = []):
	var task = {"id": _gen_id(), "name": name, "tags": tags}
	tasks.append(task)
	return task


func get_task(id: int):
	for task in tasks:
		if task["id"] == id:
			return task
	return null


func update_task(id: int, name: String, tags: PoolStringArray = []):
	var task = get_task(id)
	task["name"] = name
	task["tags"] = tags


func remove_task(id: int):
	tasks.remove(tasks.find(get_task(id)))


func tag_task(id: int, tag: String):
	var task = get_task(id)
	var tags = task["tags"]
	if not tag in tags:
		tags.append(tag)
	task["tags"] = tags


func untag_task(id: int, tag: String):
	var task = get_task(id)
	var new_tags = PoolStringArray()
	for t in task["tags"]:
		if not t == tag:
			new_tags.append(t)
	task["tags"] = new_tags


func untag_task_namespace(id: int, namespace: String):
	var task = get_task(id)
	var new_tags = PoolStringArray()
	for tag in task["tags"]:
		if not tag.begins_with(namespace + ":"):
			new_tags.append(tag)
	task["tags"] = new_tags


func get_namespace_subtag(id: int, namespace: String):
	var task = get_task(id)
	var result = PoolStringArray()
	for tag in task["tags"]:
		if tag.begins_with(namespace + ":"):
			result.append(tag.right(len(namespace) + 1))
	return result
