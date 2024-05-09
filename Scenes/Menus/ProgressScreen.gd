extends Control

@export var MovingTowardsBlocked : bool = false
var Speed : float = 128*32

@onready var progress = $Progress

signal Closed
var ClosedEmitted = false
var Ending = false

func _ready():
	progress.position = Vector2(-progress.size.x, progress.position.y)

func _process(delta):
	if MovingTowardsBlocked:
		progress.position = progress.position.move_toward(Vector2(0, progress.position.y), Speed * delta)
		if progress.position.x == 0 and not ClosedEmitted:
			Closed.emit()
			ClosedEmitted = true
	else:
		ClosedEmitted = false
		progress.position = progress.position.move_toward(Vector2(-progress.size.x, progress.position.y), Speed * delta)
		if progress.position.x == -progress.size.x and Ending:
			queue_free()

func start():
	MovingTowardsBlocked = true

func end():
	MovingTowardsBlocked = false
	Ending = true
