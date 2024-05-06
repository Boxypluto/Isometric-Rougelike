extends Projectile
class_name PedalProjectile

var Speed : float = 480
var Direction : Vector2

const AFTERIMAGE = preload("res://Scenes/Bossfights/Floweye/PedalAfterimage.tscn")
var ImageParentNode

@onready var sprite = $Sprite2D

func _process(delta):
	velocity = Direction * Speed * delta
	position += velocity
	sprite.rotation = velocity.angle() - PI/2

func _ready():
	await get_tree().create_timer(20).timeout
	queue_free()

func CreateAfterimage():
	var image = AFTERIMAGE.instantiate()
	image.rotation = sprite.rotation
	image.position = position
	ImageParentNode.add_child(image)
