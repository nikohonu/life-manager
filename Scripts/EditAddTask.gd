extends WindowDialog


signal confirmed(name, tags)

onready var tree = $MarginContainer/VBoxContainer/Tree
onready var name_line_edit = $MarginContainer/VBoxContainer/NameLineEdit
onready var tag_line_edit = $MarginContainer/VBoxContainer/HBoxContainer2/TagLineEdit
onready var root_item = tree.create_item()


func init_edit(name, tags):
	name_line_edit.text = name
	window_title = 'Edit task'
	$MarginContainer/VBoxContainer/HBoxContainer3/Confirm.text = 'Save'
	for tag in tags:
		tree.create_item(root_item).set_text(0, tag)


func clear():
	for child in get_item_children(root_item):
		child.free()
	name_line_edit.clear()
	tag_line_edit.clear()
	

func get_item_children(item: TreeItem) -> Array:
	item = item.get_children()
	var children = []
	while item:
		children.append(item)
		item = item.get_next()
	return children


func get_item_selected() -> Array:
	var item = tree.get_next_selected(null)
	var selected = []
	while item:
		selected.append(item)
		item = tree.get_next_selected(item)
	return selected

func _sort():
	var tags = PoolStringArray() 
	for child in get_item_children(root_item):
		var text = child.get_text(0)
		if not text in tags:
			tags.append(text)
		child.free()
	tags.sort()
	for tag in tags:
		tree.create_item(root_item).set_text(0, tag)


func _on_Confirm_button_up():
	var name = name_line_edit.text
	var tags = PoolStringArray()
	for child in get_item_children(root_item):
			tags.append(child.get_text(0))
	emit_signal("confirmed", name, tags)
	hide()


func _on_Cancel_button_up():
	hide()


func _on_Tag_text_entered(text: String):
	text = text.to_lower()
	if text != '':
		tree.create_item(root_item).set_text(0, text)
	tag_line_edit.text = ''
	_sort()


func _paste():
	var text: String = OS.get_clipboard()
	var is_multiline = text.find('\n') != -1
	if is_multiline:
		for t in text.split('\n'):
			t = t.strip_edges()
			if t != '':
				tree.create_item(root_item).set_text(0, t.to_lower())
	else:
		tree.create_item(root_item).set_text(0, text.to_lower())
	_sort()


func _delete():
	for item in get_item_selected():
		item.free()
	tree.update()


func _on_Tree_gui_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_DELETE:
			_delete()
		if event.pressed and event.scancode == KEY_C and event.control:
			var result = ''
			for item in get_item_selected():
				result += item.get_text(0) + '\n'
			OS.set_clipboard(result)
		if event.pressed and event.scancode == KEY_V and event.control:
			_paste()
		if event.pressed and event.scancode == KEY_A and event.control:
			for item in get_item_children(root_item):
				item.select(0)
