class Activity:
	var id: int
	var name: String
	var children: Array
	
	func _init(id: int, name: String, children: Array = []):
		self.id = id
		self.name = name
		self.children = children
