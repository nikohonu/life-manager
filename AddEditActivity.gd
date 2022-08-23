extends WindowDialog

onready var name_edit = $MarginContainer/VBoxContainer/HBoxContainer2/LineEdit
signal on_save(id, name)

var activity_id: int

func init(id: int, name: String):
	activity_id = id
	name_edit.text = name

func _ready():
	pass # Replace with function body.


func _on_Cancel_button_up():
	self.hide()


func _on_Save_button_up():
	emit_signal("on_save", activity_id, name_edit.text)
	self.hide()
