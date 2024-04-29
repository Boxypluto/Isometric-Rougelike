extends Enemy

const TOWER_PROJECTILE : PackedScene = preload("res://Objects/Enemies/Tower/TowerProjectile.tscn")

# Player
@onready var player : CharacterBody2D = $"../../Player"

func ShootProjectile():
	var projectile : TowerProjectile = TOWER_PROJECTILE.instantiate()
	projectile.Target = player.position
	get_tree().root.add_child(projectile)
	projectile.setup()
	projectile.position = position
