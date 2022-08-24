extends VBoxContainer

onready var root = get_node("/root/Root")
onready var tasks_tree = $HSplitContainer/TasksTree
onready var tags_tree = $HSplitContainer/TagsTree
onready var tasks_root_item = tasks_tree.create_item()
onready var tags_root_item = tags_tree.create_item()
onready var selected_items = []

func _ready():
	tasks_tree.set_column_title(0, 'ID')
	tasks_tree.set_column_title(1, 'Names')
	tasks_tree.set_column_expand(0, false)
	tasks_tree.set_column_min_width(0, 100)
	

func load_task(task: Dictionary):
	var item = tasks_tree.create_item(tasks_root_item)
	item.set_text(0, String(task['id']))
	item.set_text(1, task['name'])
	
	
func add_task(name: String, tags: PoolStringArray):
	var task = root.add_task(name, tags)
	var item = tasks_tree.create_item(tasks_root_item)
	item.set_text(0, String(task['id']))
	item.set_text(1, task['name'])
	
func get_item(id: int):
	for item in  get_item_children(tasks_root_item):
		if int(item.get_text(0)) == id:
			return item

func update_task(id: int, name: String, tags: PoolStringArray):
	root.update_task(id, name, tags)
	get_item(id).set_text(1, name)

func _on_Root_on_tasks_loaded():
	for task in root.tasks:
		load_task(task)

		
func get_item_selected() -> Array:
	var item = tasks_tree.get_next_selected(null)
	var selected = []
	while item:
		selected.append(item)
		item = tasks_tree.get_next_selected(item)
	return selected

func get_item_children(item: TreeItem) -> Array:
	item = item.get_children()
	var children = []
	while item:
		children.append(item)
		item = item.get_next()
	return children

func _on_Tasks_gui_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			for item in get_item_children(tasks_root_item):
				item.deselect(0)
				item.deselect(1)
		if event.pressed and event.scancode == KEY_DELETE:
			for item in get_item_selected():
				root.remove_task(int(item.get_text(0)))
				item.free()
				tasks_tree.update()
		if event.pressed and event.scancode == KEY_A and event.control:
			for item in get_item_children(tasks_root_item):
				item.select(0)
				item.select(1)

var old_items: Array

func _update_tag(force: bool = false):
	var tags = PoolStringArray()
	var items = get_item_selected()
	items = get_item_children(tasks_root_item) if items.empty() else items
	if items == old_items and not force:
		return
	old_items = items.duplicate()
	
	for item in items:
		var task = root.get_task(int(item.get_text(0)))
		for tag in task['tags']:
			if not tag in tags:
				tags.append(tag)
	tags.sort()
	for child in get_item_children(tags_root_item):
		child.free()
	for tag in tags:
		tags_tree.create_item(tags_root_item).set_text(0, tag)


func _on_Timer_timeout():
	_update_tag()


func _on_TasksTree_item_activated():
	$HBoxContainer/Edit._on_Edit_button_up()
