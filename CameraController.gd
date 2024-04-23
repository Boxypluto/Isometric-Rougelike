extends Camera2D

var ShakeFade : float = 5

var RNG = RandomNumberGenerator.new()

var CurrentStrength : float = 0

func cause_shake(strength):
	CurrentStrength = strength

func _process(delta):
	
	if CurrentStrength > 0:
		CurrentStrength = lerpf(CurrentStrength, 0, ShakeFade * delta)
	
	offset = random_offset()

func random_offset() -> Vector2:
	return Vector2(RNG.randf_range(-CurrentStrength, CurrentStrength), RNG.randf_range(-CurrentStrength, CurrentStrength))
