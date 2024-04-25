extends Button

@onready var start_menu = $".."

func OnButtomPressed():
	GameManager.DEBUG_MODE = false
	GameManager.StartGame(start_menu)
