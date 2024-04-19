extends Button

@onready var start_menu = $".."

func OnButtomPressed():
	GameManager.StartGame(start_menu)
