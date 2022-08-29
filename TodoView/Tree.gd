extends Tree

onready var root = create_item()
onready var label = $"../HBoxContainer/Label"


func get_item_selected() -> Array:
	var item = get_next_selected(null)
	var selected = []
	while item:
		selected.append(item)
		item = get_next_selected(item)
	return selected


func get_root_children() -> Array:
	var item = root.get_children()
	var children = []
	while item:
		children.append(item)
		item = item.get_next()
	return children


class TodoSorter:
	static func get_due(tags):
		var dues = Task.get_namespace_subtags(tags, "due")
		if dues:
			return dues[0]
		else:
			return ""

	static func get_priority(tags):
		var priorities = Task.get_namespace_subtags(tags, "priority")
		if priorities:
			return priorities[0]
		else:
			return ""

	static func sort(a, b):
		var due_a = get_due(a["tags"])
		var due_b = get_due(b["tags"])
		var priority_a = get_priority(a["tags"])
		var priority_b = get_priority(b["tags"])
		if due_a == due_b:
			if not priority_a:
				return false
			elif not priority_b:
				return true
			return priority_a < priority_b
		if not due_a:
			return false
		elif not due_b:
			return true
		return due_a < due_b


func set_text_from_namespace_subtag(
	item: TreeItem, column: int, tags: PoolStringArray, namespace: String, is_upper: bool = false
):
	var subtags = Task.get_namespace_subtags(tags, namespace)
	if subtags:
		if is_upper:
			item.set_text(column, subtags[0].to_upper())
		else:
			item.set_text(column, subtags[0])


func update_items():
	var current_interval = Interval.get_current_interval()
	for item in get_root_children():
		item.free()
		update()
	var tasks = Task.tasks.duplicate() as Array
	tasks.sort_custom(TodoSorter, "sort")
	for task in tasks:
		var item = create_item(root)
		item.set_text(0, String(task["id"]))
		set_text_from_namespace_subtag(item, 1, task["tags"], "priority", true)
		item.set_text(2, task["name"])
		set_text_from_namespace_subtag(item, 3, task["tags"], "status")
		set_text_from_namespace_subtag(item, 4, task["tags"], "due")
		set_text_from_namespace_subtag(item, 5, task["tags"], "recurrence")
		item.set_text_align(4, TreeItem.ALIGN_CENTER)
		if current_interval and task["id"] == current_interval["id"]:
			for i in range(6):
				item.set_custom_bg_color(i, Color.orange)
			item.select(2)


func _ready():
	set_column_title(0, "ID")
	set_column_title(1, "Priority")
	set_column_title(2, "Names")
	set_column_title(3, "Status")
	set_column_title(4, "Due")
	set_column_title(5, "Recurrence")

	set_column_expand(0, false)
	set_column_expand(1, false)
	set_column_expand(2, true)
	set_column_expand(3, false)
	set_column_expand(4, false)
	set_column_expand(5, false)

	set_column_min_width(0, 80)
	set_column_min_width(1, 80)
	set_column_min_width(2, 100)
	set_column_min_width(3, 100)
	set_column_min_width(4, 100)
	set_column_min_width(5, 90)

	update_items()
