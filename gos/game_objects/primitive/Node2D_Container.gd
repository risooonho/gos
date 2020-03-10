extends Node2D

func _ready():
	update_position()

func update_position():
	var N = self.get_children()
	
	if N.size() > 1:
		for y in N:
			y.get_node("Body").position += self.position
	
	else: 
		$'Body'.position += self.position
	
	self.position = Vector2(0,0)

