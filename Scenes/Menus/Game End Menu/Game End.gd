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
	
	var progress = GameManager.PROGRESS.instantiate()
	progress.global_position = Vector2(-progress.size.x-320, 0)
	get_tree().root.add_child(progress)
	progress.z_index = 4
	progress.start()
	
	await progress.Closed
	
	var tween : Tween = create_tween()
	tween.tween_property(GameManager.MusicPlayer, "volume_db", -80, 1)
	await tween.finished
	GameManager.MusicPlayer.stop()
	GameManager.MusicPlayer.volume_db = GameManager.MusicVolume
	
	GameManager.ResetGame(self, progress)
