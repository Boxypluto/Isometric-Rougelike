extends Area2D

@onready var room = $"../../.."

@onready var LobbyPlayer = $"../../../UneasySolace"

var IsTransitioning : bool = false

func AreaEntered(HitBox : HurtBoxComponent):
	if IsTransitioning: return
	if HitBox.HurtBoxType == "Player":
		GameManager.DEBUG_MODE = false
		
		IsTransitioning = true
		
		var progress = GameManager.PROGRESS.instantiate()
		progress.global_position = Vector2(-progress.size.x-320, 0)
		get_tree().root.add_child(progress)
		progress.z_index = 4
		progress.start()
		
		await progress.Closed
		
		var tween : Tween = create_tween()
		tween.tween_property(LobbyPlayer, "volume_db", -80, 1)
		await tween.finished
		LobbyPlayer.stop()
		LobbyPlayer.volume_db = 0
		
		room.queue_free()
		progress.end()
		IsTransitioning = false
		GameManager.StartGame()
