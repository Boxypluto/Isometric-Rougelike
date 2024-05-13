extends Projectile

var Speed : float = 128
var Direction : Vector2

@onready var sprite = $Sprite2D

func _process(delta):
	velocity = Direction * Speed * delta
	position += velocity
	sprite.rotation = velocity.angle() - PI/2

func _ready():
	await get_tree().create_timer(20).timeout
	queue_free()
