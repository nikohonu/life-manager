extends VBoxContainer

onready var tree = $Todo
onready var root_item = tree.create_item()

export var period: String


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
	var data = {"due": "", "priority": "", "recurrence": ""}
	for tag in tags:
		for key in data:
			if tag.begins_with(key + ":"):
				data[key] = tag.right(len(key) + 1)
	return data


func _update():
	for item in get_item_children(root_item):
		item.free()
		tree.update()
	Root.tasks.sort_custom(self, "todo_comparison")
	for task in Root.tasks:
		var item = tree.create_item(root_item)
		var data = get_data(task["tags"])
		var statuses = get_status(task["id"])
		var status = ""
		if statuses:
			status = statuses[0]

		print(task["tags"])
		item.set_text(0, String(task["id"]))
		item.set_text(1, data["priority"].to_upper())
		item.set_text(2, task["name"])
		item.set_text(3, status)
		item.set_text(4, data["due"])
		item.set_text(5, data["recurrence"])
		for i in range(3, 6):
			item.set_text_align(i, ALIGN_END)


func todo_comparison(task_a, task_b):
	var data_a = get_data(task_a["tags"])
	var data_b = get_data(task_b["tags"])

	if data_a["due"] == data_b["due"]:
		if not data_a["priority"]:
			return false
		if not data_b["priority"]:
			return true
		return data_a["priority"] < data_b["priority"]
	if not data_a["due"]:
		return false
	if not data_b["due"]:
		return true
	return data_a["due"] < data_b["due"]


func _ready():
	tree.set_column_title(0, "ID")
	tree.set_column_expand(0, false)
	tree.set_column_min_width(0, 90)
	tree.set_column_title(1, "priority")
	tree.set_column_expand(1, false)
	tree.set_column_min_width(1, 90)
	tree.set_column_title(2, "Names")
	tree.set_column_min_width(2, 100)
	tree.set_column_title(3, "Status")
	tree.set_column_min_width(3, 90)
	tree.set_column_expand(3, false)
	tree.set_column_title(4, "Due")
	tree.set_column_expand(4, false)
	tree.set_column_min_width(4, 90)

	tree.set_column_title(5, "Recurrence")
	tree.set_column_expand(5, false)

	tree.set_column_min_width(5, 90)
	_update()


func _set_due(id: int, due: Dictionary):
	if due:
		var tag = "due:%04d-%02d-%02d" % [due["year"], due["month"], due["day"]]
		Root.untag_task_namespace(id, "due")
		Root.tag_task(id, tag)
	else:
		Root.untag_task_namespace(id, "due")


func get_due(id: int):
	var dues = Root.get_namespace_subtag(id, "due")
	if dues:
		var data = Time.get_datetime_dict_from_datetime_string("%sT00:00:00" % dues[0], false)
		return {
			"day": data["day"],
			"month": data["month"],
			"year": data["year"],
		}
	return {}


func _set_priority(id: int, priority: String):
	if priority:
		var tag = "priority:" + priority
		Root.untag_task_namespace(id, "priority")
		Root.tag_task(id, tag)
	else:
		Root.untag_task_namespace(id, "priority")


func get_priority(id: int):
	var priorities = Root.get_namespace_subtag(id, "priority")
	if priorities:
		return priorities[0]
	return ""


func _set_recurrence(id: int, recurrence: Dictionary):
	if recurrence:
		var tag = "recurrence:%d%s" % [recurrence["interval"], recurrence["unit"]]
		Root.untag_task_namespace(id, "recurrence")
		Root.tag_task(id, tag)
	else:
		Root.untag_task_namespace(id, "recurrence")


func get_recurrence(id: int):
	var recurrences = Root.get_namespace_subtag(id, "recurrence")
	if recurrences:
		return {
			"interval": recurrences[0].left(len(recurrences[0]) - 1),
			"unit": recurrences[0].right(len(recurrences[0]) - 1)
		}
	return {}


func get_status(id: int):
	var status = Root.get_namespace_subtag(id, "status")
	if status:
		return status
	return ""


func add_todo(name: String, due: Dictionary, priority: String, recurrence: Dictionary):
	var task = Root.add_task(name)
	var id = task["id"]
	update_todo(id, name, due, priority, recurrence)


func update_todo(id, name: String, due: Dictionary, priority: String, recurrence: Dictionary):
	var task = Root.get_task(id)
	task["name"] = name
	_set_due(id, due)
	_set_priority(id, priority)
	_set_recurrence(id, recurrence)
	_update()


func complete(id: int):
	Root.untag_task_namespace(id, "status")
	Root.tag_task(id, "status:completed")
	_update()
