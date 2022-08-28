extends Timer

onready var label = $"../HBoxContainer/Label"


func _ready():
	pass


func _on_UpdateStatus_timeout():
	var current_interval = Root.get_current_interval()
	if current_interval:
		var task = Root.get_task(current_interval["id"])
		label.text = "The current task is %s" % task["name"]
		print(task["name"])
	else:
		label.text = "There is no task"
