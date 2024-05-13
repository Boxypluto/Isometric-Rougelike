extends Enemy

const BLAST = preload("res://Objects/Enemies/Blaster/BlasterBlast.tscn")
@onready var blast_sound : AudioStreamPlayer2D = $Blast

func OnHealthZero():
	death.Kill()

func BlasterHit(damage):
	health.DealDamage(damage)

func Shoot():
	blast_sound.play()
	for index in range(8):
		var blast : Projectile = BLAST.instantiate()
		var sprite = blast.get_node("Sprite")
		sprite.rotation = index * (2*PI/8.0)
		print(sprite.rotation)
		add_child(blast)
