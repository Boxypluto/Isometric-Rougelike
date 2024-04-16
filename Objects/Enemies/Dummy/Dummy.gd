extends Enemy

func DummyIsHit(damage):
	health.DealDamage(damage)

func OnZeroHealth():
	death.Kill()
