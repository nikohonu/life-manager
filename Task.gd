extends Node

var tasks


func _load():
	var task_file = File.new()
	task_file.open("user://tasks.json", File.READ)
	tasks = parse_json(task_file.get_as_text())
	if not tasks:
		tasks = []
	task_file.close()


func _save():
	var task_file = File.new()
	task_file.open("user://tasks.json", File.WRITE)
	task_file.store_string(to_json(tasks))
	task_file.close()


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


func tag(tags: PoolStringArray, tag: String):
	var new_tags = tags  # try directly
	if not tag in new_tags:
		new_tags.append(tag)
	return new_tags


func tag_by_id(id: int, tag: String):
	var task = get_task(id)
	task["tags"] = tag(task["tags"], tag)


func untag_task(id: int, tag: String):
	var task = get_task(id)
	var new_tags = PoolStringArray()
	for t in task["tags"]:
		if not t == tag:
			new_tags.append(t)
	task["tags"] = new_tags


func untag_namespace(tags: PoolStringArray, namespace: String):
	var new_tags = PoolStringArray()
	for tag in tags:
		if not tag.begins_with(namespace + ":"):
			new_tags.append(tag)
	return new_tags


func untag_namespace_by_id(id: int, namespace: String):
	var task = get_task(id)
	task["tags"] = untag_namespace(task["tags"], namespace)


func get_namespace_subtags(tags, namespace: String):
	var result = PoolStringArray()
	for tag in tags:
		if tag.begins_with(namespace + ":"):
			result.append(tag.right(len(namespace) + 1))
	return result


func get_namespace_subtags_by_id(id: int, namespace: String):
	var task = get_task(id)
	return get_namespace_subtags(task["tags"], namespace)
