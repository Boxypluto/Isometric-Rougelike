extends Control

@onready var player = $"../Y-Sortables/Player"
@onready var health_label = $HealthLabel

func _process(delta):
	health_label.text = "Health: " + str(player.health.Health)
