extends Node2D

@onready var state_machine : StateMachine = $StateMachine
@onready var summon_vines : SummonVinesState = $StateMachine/SummonVinesState
@onready var shoot_flowers : ShootFlowersState = $StateMachine/ShootFlowersState
@onready var pedal_volley : PedalVolleyState = $StateMachine/PedalVolleyState

@onready var room : Room = $"../.."

const StateArray : Array[String] = [
	"summon_vines",
	"shoot_flowers",
	"shoot_flowers",
	"shoot_flowers",
	"shoot_flowers",
	"pedal_volley",
	"pedal_volley",
	"pedal_volley"
]

var CurrentStateArray : Array[String]

@onready var enemies = $"../Enemies"

@onready var health : HealthComponent = $HealthComponent

@onready var flower : Spin = $Face/Flower
var FlowerInitSpeed : float
var FlowerFastSpeed : float = 2

@onready var player = $"../Player"

var GrowSpotArray : Array[Node2D] = [
	$VineSummoner1,
	$VineSummoner2,
	$VineSummoner3,
	$VineSummoner4,
	$VineSummoner5,
	$VineSummoner6,
	$VineSummoner7
]

@onready var flower_summoner_1 = $FlowerSummoner1
@onready var flower_summoner_2 = $FlowerSummoner2
@onready var flower_summoner_3 = $FlowerSummoner3
@onready var flower_summoner_4 = $FlowerSummoner4
@onready var flower_summoner_5 = $FlowerSummoner5
@onready var flower_summoner_6 = $FlowerSummoner6

var FlowerSpotDict : Dictionary = {
}

const FLASH_MAT : ShaderMaterial = preload("res://Objects/Enemies/EnemyFlashMAT.tres")

@onready var health_bar : ProgressBar = $HealthBar
@onready var hurt_box = $HurtBoxComponent

func _ready():
	
	hurt_box.Hit.connect(Callable(self, "OnHit"))
	material = FLASH_MAT.duplicate()
	health_bar.max_value = health.Health
	
	FlowerSpotDict[0] = [flower_summoner_1, flower_summoner_2]
	FlowerSpotDict[1] = [flower_summoner_3, flower_summoner_4]
	FlowerSpotDict[2] = [flower_summoner_5, flower_summoner_6]
	
	FlowerInitSpeed = flower.speed
	
	# Setup Summon Vines State
	summon_vines.GrowSpotArray = get_tree().get_nodes_in_group("VineSummoner")
	summon_vines.EnemiesNode = enemies
	
	# Setup Shoot Flowers State
	shoot_flowers.Parent = self
	shoot_flowers.PositionsDict = FlowerSpotDict
	
	# Setup Fire Pedals State
	pedal_volley.FireTimes = 5
	pedal_volley.FireNode = flower
	pedal_volley.TargetNode = player
	pedal_volley.ProjectileOwner = self
	
	await get_tree().create_timer(3.20).timeout
	
	# Setup State Machine
	state_machine.initial_state = summon_vines
	state_machine.setup()

func StateComplete():
	
	if CurrentStateArray == []:
		print("RESHUFFLE")
		for entry in StateArray:
			CurrentStateArray.append(entry)
		CurrentStateArray.shuffle()
		print("NEW ARRAY: " + str(CurrentStateArray))
	
	#flower.speed = FlowerInitSpeed
	
	await get_tree().create_timer(2).timeout
	
	print(CurrentStateArray)
	
	var NextState : String = CurrentStateArray.pop_back()
	
	if NextState == "summon_vines":
		state_machine.change_state(summon_vines.name)
	elif NextState == "shoot_flowers":
		#flower.Speed = FlowerInitSpeed
		state_machine.change_state(shoot_flowers.name)
	elif NextState == "pedal_volley":
		state_machine.change_state(pedal_volley.name)
	else:
		print("INVALID STATE!")

func _process(delta):
	
	health_bar.value = clamp(health.Health, 0, 64000000)
	
	if health.Health <= 0:
		room.ProgressRooms()

func FloweyeHit(damage):
	health.DealDamage(damage)

func OnHealthZero():
	pass # Replace with function body.

func OnHit(damage):
	material.set_shader_parameter("White", true)
	await get_tree().create_timer(0.1).timeout
	material.set_shader_parameter("White", false)
