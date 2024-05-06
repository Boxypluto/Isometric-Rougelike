extends Node2D
@export var Amplitude : float
@export var Frequency : float

var InitPos : Vector2
var frames : int

func _ready():
	InitPos = position

func _process(delta):
	frames += 1
	position = Vector2(InitPos.x, InitPos.y + sin(frames / 60.0 * Frequency) * Amplitude)
