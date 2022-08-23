extends Control

onready var tree = $VBoxContainer2/Tree

var root

var activities = []
onready var Activity = load("res://Activity.gd")


func get_new_id():
	var ids = []
	for activity in activities:
		ids.append(activity['id'])
	if ids:
		return ids.max() + 1
	else:
		return 0


func get_selected_activity():
	var selected_item = tree.get_selected()
	for activity in activities:
		for item in activity['items']:
			if item == selected_item:
				return activity['id']
	return null


func get_activity_by_id(id: int, data=self.activities):
	for activity in data:
		if activity['id'] == id:
			return activity


func add_activity(id: int, name: String, parents: Array = []):
	var items = []
	if parents:
		for parent_id in parents:
			var parent = get_activity_by_id(parent_id)
			parent['children'].append(id)
			for item in parent['items']:
				var new_item = tree.create_item(item)
				items.append(new_item)
	else:
		var new_item = tree.create_item()
		items.append(new_item)
	for item in items:
		item.set_text(0, name)
	activities.append({
		'id': id,
		'name': name,
		'children': [],
		'parents': parents,
		'items': items
	})

func delete_activity(id: int):
	var activity = get_activity_by_id(id)
	for child in activity['children']:
		delete_activity(child)
	for item in activity['items']:
		item.free()
	activities.remove(activities.find(activity))
	tree.update()


func load_activities():
	var file = File.new()
	file.open("user://activities.json", File.READ)
	var data = parse_json(file.get_as_text())
	var queue = []
	for activity in data:
		if not activity['parents']:
			queue.append(activity['id'])
	queue.invert()
	while queue:
		var activity_id = queue.pop_back()
		var activity = get_activity_by_id(activity_id, data)
		if activity:
			var children = activity['children']
			children.invert()
			queue.append_array(children)
			print(activity)
			add_activity(activity['id'], activity['name'], activity['parents'])
	file.close()


func save_activities():
	for activity in activities:
		activity.erase('items')
	var file = File.new()
	file.open("user://activities.json", File.WRITE)
	file.store_string(to_json(activities))
	file.close()

func _ready():
	root = tree.create_item()
	root.set_text(0, 'activities')
	load_activities()


func _on_AddButton_button_up():
	var selected = get_selected_activity()
	var parents = [selected] if selected else []
	add_activity(get_new_id(), "test", parents)


func _on_DeleteButton_button_up():
	var activit_id = get_selected_activity()
	if activit_id == null:
		pass
	else:
		delete_activity(activit_id)


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_activities()
		pass
