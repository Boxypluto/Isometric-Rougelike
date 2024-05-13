extends Control

@onready var player = $"../Y-Sortables/Player"

func _ready():
	var bits = get_tree().get_nodes_in_group("HealthBit")
	for bit in bits:
		bit.player = player
