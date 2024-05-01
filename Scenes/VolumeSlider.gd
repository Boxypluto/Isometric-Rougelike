extends HSlider

@export var Bus : String
var TickSound : bool = true

const TICK = preload("res://SFX/Tick.wav")
@onready var player = AudioStreamPlayer.new()

func _ready():
	value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(Bus)))
	player.stream = TICK
	player.bus = "SFX"
	add_child(player)

func SliderChanged(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(Bus), linear_to_db(value))
	if TickSound == true:
		player.play()
		TickSound = false
		TickTimer()

func TickTimer():
	await get_tree().create_timer(0.1).timeout
	TickSound = true
