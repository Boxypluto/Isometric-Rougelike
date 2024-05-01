extends Enemy

const BLAST = preload("res://Objects/Enemies/Blaster/BlasterBlast.tscn")

func OnHealthZero():
	death.Kill()

func BlasterHit(damage):
	health.DealDamage(damage)

func Shoot():
	for index in range(8):
		var blast : Projectile = BLAST.instantiate()
		blast.rotation = index * (2*PI/8.0)
		print(blast.rotation)
		add_child(blast)
