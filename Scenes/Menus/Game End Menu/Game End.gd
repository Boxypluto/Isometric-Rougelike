extends Control

@onready var game_over = $"Game Over"
@onready var congradulations = $Congradulations

@onready var damage_dealt = $"Damage Dealt"
@onready var damage_taken = $"Damage Taken"
@onready var enemies_defeated = $"Enemies Defeated"

func enter(GameWon : bool):
	if GameWon:
		game_over.visible = false
		congradulations.visible = true
	else:
		game_over.visible = true
		congradulations.visible = false
		
	damage_dealt.text = "Damage Dealt: " + str(GameManager.DamageDealt)
	damage_taken.text = "Damage Taken: " + str(GameManager.DamageTaken)
	enemies_defeated.text = "Enemies Defeated: " + str(GameManager.EnemiesDefeated)

func ContinueButtonPressed():
	
	GameManager.DamageDealt = 0
	GameManager.DamageTaken = 0
	GameManager.EnemiesDefeated = 0
	
	GameManager.ResetGame(self)
