extends Button

onready var life = $"../.."
onready var edit_scene = load("res://AddEditActivity.tscn")


func _on_Edit_button_up():
	var activit_id = life.get_selected_activity()
	if activit_id == null:
		pass
	else:
		var activity = life.get_activity_by_id(activit_id)
		var edit = edit_scene.instance()
		add_child(edit)
		edit.init(activity['id'], activity['name'])
		edit.connect("on_save", self, "_on_save")
		edit.popup()
		
		
func _on_save(id: int, name: String):
	var activity = life.get_activity_by_id(id)
	if activity and name:
		activity['name'] = name
		for item in activity['items']:
			item.set_text(0, name)
