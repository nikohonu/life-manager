extends Button

const DAY = 60 * 60 * 24

onready var tree = $"../../Tree"


func _on_Done_button_up():
	var selected = tree.get_item_selected()
	if selected:
		Interval.stop_interval()
		var task = Task.get_task(int(selected[0].get_text(0)))
		var recurrences = Task.get_namespace_subtags(task["tags"], "recurrence")
		if not recurrences:
			task["tags"] = Task.untag_namespace(task["tags"], "status")
			task["tags"] = Task.tag(task["tags"], "status:completed")
			tree.update_items()
		else:
			var dues = Task.get_namespace_subtags(task["tags"], "due")
			var due: int
			if dues:
				due = Time.get_unix_time_from_datetime_string("%sT00:00:00" % dues[0])
			else:
				due = Time.get_unix_time_from_datetime_string(
					Time.get_datetime_string_from_system()
				)
			var interval = int(recurrences[0].left(len(recurrences[0]) - 1))
			match recurrences[0].right(len(recurrences[0]) - 1):
				"d":
					interval = interval
				"w":
					interval = interval * 7
				"m":
					interval = interval * 7 * 4
				"y":
					interval = interval * 7 * 4 * 12
				_:
					return
			var new_due = Time.get_date_string_from_unix_time(due + interval * DAY)
			task["tags"] = Task.untag_namespace(task["tags"], "due")
			task["tags"] = Task.tag(task["tags"], "due:%s" % new_due)
		tree.update_items()
