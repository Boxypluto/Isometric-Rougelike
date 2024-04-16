extends Enemy

func FlareIsHit(damage):
	health.DealDamage(damage)

func OnHealthZero():
	death.Kill()
