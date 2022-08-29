extends Timer

onready var label = $"../HBoxContainer/Label"


func _ready():
	_on_UpdateStatus_timeout()


func sec_time_string(sec: int):
	if sec < 60:
		return "%ds" % sec
	elif sec / 60 < 60:
		return "%dm" % int(sec / 60)
	else:
		return "%dh" % int(sec / 60 / 60)


func _on_UpdateStatus_timeout():
	var current_interval = Interval.get_current_interval()
	if current_interval:
		var start = Time.get_unix_time_from_datetime_dict(current_interval["start"])
		var now = Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system())
		var task = Task.get_task(current_interval["id"])
		label.text = "The current task is %s (%s)" % [task["name"], sec_time_string(now - start)]
	else:
		label.text = "There is no task"
