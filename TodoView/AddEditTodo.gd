extends WindowDialog


signal confirmed(name, due, time, interval)


onready var name_line_edit = $MarginContainer/VBoxContainer/GridContainer/NameLineEdit
onready var year_option = $MarginContainer/VBoxContainer/GridContainer/HBoxContainer/Year
onready var month_option = $MarginContainer/VBoxContainer/GridContainer/HBoxContainer/Month
onready var day_option = $MarginContainer/VBoxContainer/GridContainer/HBoxContainer/Day
onready var hour_option = $MarginContainer/VBoxContainer/GridContainer/HBoxContainer2/Hour
onready var minute_option = $MarginContainer/VBoxContainer/GridContainer/HBoxContainer2/Minute
onready var interval_line_edit = $MarginContainer/VBoxContainer/GridContainer/HBoxContainer3/Interval
onready var unit_option = $MarginContainer/VBoxContainer/GridContainer/HBoxContainer3/Unit


func get_number_of_days(month: int, year: int):
	if month == 2:
		if year%400 == 0 or year % 4 == 0 and year % 100 != 0:
			return 29
		else:
			return 28
	elif month == 1 or month == 3 or month == 5 or month == 7 or month == 8 or month == 10 or month==12:
		return 31
	else:
		return 30
	
	
func clear():
	var datetime = Time.get_datetime_dict_from_system()
	name_line_edit.clear()
	interval_line_edit.text = '1'
	year_option._select_int(0)
	month_option._select_int(datetime['month']-1)
	day_option._select_int(datetime['day']-1)
	hour_option._select_int(datetime['hour'])
	minute_option._select_int(datetime['minute'])
	unit_option._select_int(0)
	return datetime


func init_edit(name: String, due: String, time: String, recurrence: String):
	window_title = 'Edit todo'
	$MarginContainer/VBoxContainer/HBoxContainer/Confirm.text = 'Save'
	var datetime = Time.get_datetime_dict_from_system()
	name_line_edit.text = name
	if due:
		var year = int(due.left(4))
		year_option._select_int(year - datetime['year'])
		var month = int(due.right(5).left(2))
		month_option._select_int(month-1)
		var day = int(due.right(8))
		day_option._select_int(day-1)
	if time:
		var hour = int(time.left(2))
		hour_option._select_int(hour)
		var minute = int(time.right(3))
		minute_option._select_int(minute)
	if recurrence:
		interval_line_edit.text = recurrence.left(len(recurrence)-1)
		match recurrence.right(1):
			'd':
				unit_option._select_int(0)
			'w':
				unit_option._select_int(1)
			'm':
				unit_option._select_int(2)
			'y':
				unit_option._select_int(3)

func _ready():
	var datetime = Time.get_datetime_dict_from_system()
	for year in range(datetime['year'], datetime['year']+11):
		year_option.add_item(String(year))
	for month in range(1, 13):
		month_option.add_item(String(month))
	for day in range(1, get_number_of_days(datetime['month'], datetime['year'])+1):
		day_option.add_item(String(day))
	for hour in range(0, 24):
		hour_option.add_item(String(hour))
	for minute in range(0, 60):
		minute_option.add_item(String(minute))
	for unit in ['days', 'weeks', 'months', 'years']:
		unit_option.add_item(String(unit))


func get_selected_text(option_button: OptionButton):
	return option_button.get_item_text(option_button.get_selected_id())
	
	
func _on_Confirm_button_up():
	var name = name_line_edit.text
	var tags = PoolStringArray()
	var due = "%s-%02d-%02d" % [get_selected_text(year_option),
								int(get_selected_text(month_option)), 
								int(get_selected_text(day_option))]
	var time = "%02d:%02d" % [int(get_selected_text(hour_option)),
								int(get_selected_text(minute_option))]
	var interval = int(interval_line_edit.text)
	var unit = ''
	match get_selected_text(unit_option):
		'days':
			unit = 'd'
		'weeks':
			unit = 'w'
		'months':
			unit = 'm'
		'years':
			unit = 'y'
		_:
			unit = 'd'
	var recurrence = "%d%s" % [interval, unit]
	if interval > 0 and name:
		emit_signal("confirmed", name, due, time, recurrence)
		hide()


func _on_Cancel_button_up():
	hide()
