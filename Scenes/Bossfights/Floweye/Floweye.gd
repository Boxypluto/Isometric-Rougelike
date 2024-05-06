extends Node2D

@onready var state_machine : StateMachine = $StateMachine
@onready var summon_vines : SummonVinesState = $StateMachine/SummonVinesState
@onready var shoot_flowers : ShootFlowersState = $StateMachine/ShootFlowersState

@onready var enemies = $"../Enemies"

@onready var health : HealthComponent = $HealthComponent

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
	
	FlowerSpotDict[0] = [flower_summoner_1, flower_summoner_2]
	FlowerSpotDict[1] = [flower_summoner_3, flower_summoner_4]
	FlowerSpotDict[2] = [flower_summoner_5, flower_summoner_6]
	
	# Setup Summon Vines State
	summon_vines.GrowSpotArray = get_tree().get_nodes_in_group("VineSummoner")
	summon_vines.EnemiesNode = enemies
	
	# Setup State Machine
	state_machine.setup()
	
	await get_tree().create_timer(2).timeout
	
	shoot_flowers.PositionsDict = FlowerSpotDict
	state_machine.change_state(shoot_flowers.name)
	
	await  get_tree().create_timer(4).timeout
	
	state_machine.change_state(summon_vines.name)

func _process(delta):
	health_bar.value = health.Health

func FloweyeHit(damage):
	health.DealDamage(damage)

func OnHealthZero():
	pass # Replace with function body.

func OnHit(damage):
	material.set_shader_parameter("White", true)
	await get_tree().create_timer(0.1).timeout
	material.set_shader_parameter("White", false)
