extends Node

var intervals


func _load():
	var interval_file = File.new()
	interval_file.open("user://intervals.json", File.READ)
	intervals = parse_json(interval_file.get_as_text())
	if not intervals:
		intervals = []
	interval_file.close()


func _save():
	var interval_file = File.new()
	interval_file.open("user://intervals.json", File.WRITE)
	interval_file.store_string(to_json(intervals))
	interval_file.close()


func _ready():
	_load()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_save()


func start_interval(id: int):
	if intervals and not intervals[-1]["end"]:
		return
	var interval = {"id": id, "start": Time.get_datetime_dict_from_system(), "end": {}}
	intervals.append(interval)


func stop_interval():
	if intervals[-1]:
		intervals[-1]["end"] = Time.get_datetime_dict_from_system()


func get_current_interval():
	if intervals and not intervals[-1]["end"]:
		return intervals[-1]
