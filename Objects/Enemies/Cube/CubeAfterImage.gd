extends AnimatedSprite2D

var opacity : float = 0.3

func setup(Frame : int):
	speed_scale = 0
	frame = Frame

func _physics_process(delta):
	
	modulate.a = opacity
	opacity -= 0.01
	
	if opacity == 0: queue_free()
