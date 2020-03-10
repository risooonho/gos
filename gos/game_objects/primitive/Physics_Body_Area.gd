extends Area2D

onready var area_body = get_parent()

func _ready():
	refresh_body_shape()

func refresh_body_shape():
	var area_shape = $'Area_Shape'
	
	area_shape.shape = area_body.get_node("Body_Shape").get_shape()
	area_shape.position = area_body.get_node("Body_Shape").position