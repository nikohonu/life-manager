extends WindowDialog

signal confirmed(name, due, priority, recurrence)

onready var name_edit = $MarginContainer/VBoxContainer/GridContainer/NameLineEdit
onready var due_check_box = $MarginContainer/VBoxContainer/GridContainer/Due/CheckBox
onready var year_option = $MarginContainer/VBoxContainer/GridContainer/DueOptions/Year
onready var month_option = $MarginContainer/VBoxContainer/GridContainer/DueOptions/Month
onready var day_option = $MarginContainer/VBoxContainer/GridContainer/DueOptions/Day
onready var priority_check_box = $MarginContainer/VBoxContainer/GridContainer/Priority/CheckBox
onready var priority_option = $MarginContainer/VBoxContainer/GridContainer/PriorityOption
onready var recurrence_check_box = $MarginContainer/VBoxContainer/GridContainer/Recurrence/CheckBox
onready var recurrence_edit = $MarginContainer/VBoxContainer/GridContainer/RecurrenceOption/LineEdit
onready var recurrence_option = $MarginContainer/VBoxContainer/GridContainer/RecurrenceOption/OptionButton

var letters: Dictionary


func get_number_of_days(month: int, year: int):
	if month == 2:
		if year % 400 == 0 or year % 4 == 0 and year % 100 != 0:
			return 29
		else:
			return 28
	elif (
		month == 1
		or month == 3
		or month == 5
		or month == 7
		or month == 8
		or month == 10
		or month == 12
	):
		return 31
	else:
		return 30


func clear():
	var datetime = Time.get_datetime_dict_from_system()
	name_edit.clear()
	due_check_box.pressed = false
	year_option._select_int(0)
	month_option._select_int(datetime["month"] - 1)
	day_option._select_int(datetime["day"] - 1)
	priority_check_box.pressed = false
	priority_option._select_int(0)
	recurrence_check_box.pressed = false
	recurrence_edit.text = "1"
	recurrence_option._select_int(0)
	self._on_CheckBox_pressed()


func init_edit(name: String, due: Dictionary, priority: String, recurrence: Dictionary):
	window_title = "Edit todo"
	$MarginContainer/VBoxContainer/HBoxContainer/Confirm.text = "Save"
	var datetime = Time.get_datetime_dict_from_system()
	name_edit.text = name
	if due:
		year_option._select_int(due["year"] - datetime["year"])
		month_option._select_int(due["month"] - 1)
		day_option._select_int(due["day"] - 1)
		due_check_box.pressed = true
	if priority:
		priority_option._select_int(letters[priority])
		priority_check_box.pressed = true
	if recurrence:
		recurrence_edit.text = String(recurrence["interval"])
		match recurrence["unit"]:
			"d":
				recurrence_option._select_int(0)
			"w":
				recurrence_option._select_int(1)
			"m":
				recurrence_option._select_int(2)
			"y":
				recurrence_option._select_int(3)
		recurrence_check_box.pressed = true
	self._on_CheckBox_pressed()


func _ready():
	var datetime = Time.get_datetime_dict_from_system()
	for year in range(datetime["year"], datetime["year"] + 11):
		year_option.add_item(String(year))
	for month in range(1, 13):
		month_option.add_item(String(month))
	for day in range(1, get_number_of_days(datetime["month"], datetime["year"]) + 1):
		day_option.add_item(String(day))
	for priority in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
		priority_option.add_item(priority)
	for recurrence in ["days", "weeks", "months", "years"]:
		recurrence_option.add_item(recurrence)
	var i = 0
	for letter in "abcdefghijklmnopqrstuvwxyz":
		letters[letter] = i
		i += 1


func get_selected_text(option_button: OptionButton):
	return option_button.get_item_text(option_button.get_selected_id())


func _on_Confirm_button_up():
	var name = name_edit.text
	if name:
		var due = (
			{
				"year": int(get_selected_text(year_option)),
				"month": int(get_selected_text(month_option)),
				"day": int(get_selected_text(day_option)),
			}
			if due_check_box.pressed
			else {}
		)
		var priority = (
			get_selected_text(priority_option).to_lower()
			if priority_check_box.pressed
			else ""
		)
		var recurrence = (
			{
				"interval": int(recurrence_edit.text),
				"unit": get_selected_text(recurrence_option).left(1)
			}
			if recurrence_check_box.pressed
			else {}
		)
		if not recurrence.empty():
			if recurrence["interval"] <= 0:
				return
		emit_signal("confirmed", name, due, priority, recurrence)
		hide()


func _on_Cancel_button_up():
	hide()


func _on_CheckBox_pressed():
	if due_check_box.pressed:
		year_option.disabled = false
		month_option.disabled = false
		day_option.disabled = false
	else:
		year_option.disabled = true
		month_option.disabled = true
		day_option.disabled = true
	if priority_check_box.pressed:
		priority_option.disabled = false
	else:
		priority_option.disabled = true
	if recurrence_check_box.pressed:
		recurrence_edit.editable = true
		recurrence_option.disabled = false
	else:
		recurrence_edit.editable = false
		recurrence_option.disabled = true
