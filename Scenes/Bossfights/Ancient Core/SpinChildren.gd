extends Node2D

var Children : Array
@export var Speed : float

func _ready(): Children = get_children()

func _process(delta):
	for child in Children:
		child.rotation += Speed * delta
