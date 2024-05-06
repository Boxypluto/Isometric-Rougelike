extends Sprite2D

func _process(delta):
	modulate.a -= 0.03
	if modulate.a - 0.03 < 0.0:
		queue_free()
