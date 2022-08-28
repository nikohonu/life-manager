extends Button

onready var todo_view = $"../.."


func _ready():
	pass


func _on_Stop_button_up():
	Root.stop_interval()
