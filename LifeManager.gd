extends Control


var activities = ['test1', 'test2']
var items = []
onready var tree = $HBoxContainer/Tree

var root
# Called when the node enters the scene tree for the first time.
func _ready():
	root = $HBoxContainer/Tree.create_item()
	root.set_text(0, 'Activities')
	for activity in activities:
		var item = $HBoxContainer/Tree.create_item(root)
		item.set_text(0, activity)


func _on_AddButton_button_up():
	var selected = tree.get_selected()
	var item = tree.create_item(selected)
	item.set_text(0, "Test")


func _on_DeleteButton_button_up():
	var selected = tree.get_selected()
	if selected and selected != root:
		tree.get_selected().free()
		tree.update()
