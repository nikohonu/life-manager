extends Button

onready var todo_view = $"../.."

const DAY = 60 * 60 * 24


func _ready():
	pass


func _on_Done_button_up():
	var selected = todo_view.get_item_selected()
	if selected:
		var id = int(selected[0].get_text(0))
		var task = Root.get_task(id)
		var due = todo_view.get_due(id)
		var recurrence = todo_view.get_recurrence(id)
		if due and not recurrence:
			todo_view.complete(id)
		elif recurrence:
			due = due if due else Time.get_datetime_dict_from_system()
			print(due, recurrence)
##		if data:
##		if date['date'] and not data['recurrence']:
#		if data['recurrence']:
#			var interval = int(data['recurrence'].left(len(data['recurrence'])-1))
#			match data['recurrence'].right(1):
#				'd':
#					interval *= 1
#				'w':
#					interval *= 7
#				'm':
#					interval *= 28
#				'y':
#					interval *= 28 * 12
#			var unix_time = Time.get_unix_time_from_datetime_string ('%sT00:00:00' % data['due']) + DAY * interval
#			var datetime_string = Time.get_datetime_string_from_unix_time(unix_time)
