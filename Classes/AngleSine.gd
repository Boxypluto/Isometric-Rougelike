extends Node2D
class_name AngleSine

@export var Amplitude : float
@export var Frequency : float

var InitAngle
@export var OffsetFrames : float
var frames : int

func _ready():
	InitAngle = rotation

func _process(delta):
	frames += 1
	rotation = (InitAngle + sin((frames + OffsetFrames) / 60.0 * Frequency) * Amplitude)
