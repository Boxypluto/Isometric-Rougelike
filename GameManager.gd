extends Node

var DEBUG_MODE = true

var TestingRooms : Array = [
	preload("res://Scenes/Rooms/Room 1.tscn"),
	preload("res://Scenes/Rooms/Room 2.tscn"),
	preload("res://Scenes/Rooms/Room 3.tscn")
]

var Area1 : Array = [
	preload("res://Scenes/Areas/Area 1/Archipelago.tscn"),
	preload("res://Scenes/Areas/Area 1/FortressWall.tscn"),
	preload("res://Scenes/Areas/Area 1/GrassIslands.tscn"),
	preload("res://Scenes/Areas/Area 1/LoopAround.tscn"),
	preload("res://Scenes/Areas/Area 1/Sparse.tscn")
]

var Area2 : Array = [
	preload("res://Scenes/Areas/Area 2/Arena.tscn"),
	preload("res://Scenes/Areas/Area 2/SpikePit.tscn"),
	preload("res://Scenes/Areas/Area 2/ThinPeak.tscn"),
	preload("res://Scenes/Areas/Area 2/ValleyRidge.tscn"),
	preload("res://Scenes/Areas/Area 2/ZigZag.tscn")
]

var Area3 : Array = [
	preload("res://Scenes/Areas/Area 3/BioSpheres.tscn"),
	preload("res://Scenes/Areas/Area 3/LonelyStation.tscn"),
	preload("res://Scenes/Areas/Area 3/Satellites.tscn"),
	preload("res://Scenes/Areas/Area 3/Ships.tscn"),
	preload("res://Scenes/Areas/Area 3/Spread.tscn")
]

var AreaLevelCount : int = 3

var Areas : Dictionary = {
	"Area1" : Area1,
	"Area2" : Area2,
	"Area3" : Area3
}

var WorldDictionary : Dictionary = {}
var AreaArray : Array

var CurrentRoomIndex : int
var CurrentAreaIndex : int
var CurrentRoomScene : Node

func GenerateRooms():
	
	WorldDictionary.clear()
	AreaArray.clear()
	
	for area in range(len(Areas)):
		
		var AreaDictionary : Dictionary
		var LevelList : Array
		for scene in Areas.values()[area]:
			LevelList.append(scene)
			
		
		WorldDictionary[area] = { }
		
		for room in range(AreaLevelCount):
			
			var LevelIndex = randi_range(0, len(LevelList)-1)
			var Level = LevelList[LevelIndex]
			LevelList.pop_at(LevelIndex)
			
			WorldDictionary[area][room] = Level
	
	print(WorldDictionary)

func StartGame(scene_to_remove = null):
	GenerateRooms()
	
	CurrentAreaIndex = 0
	CurrentRoomIndex = 0
	
	var room = WorldDictionary.values()[CurrentAreaIndex][CurrentRoomIndex].instantiate()
	get_tree().root.add_child(room)
	
	if scene_to_remove is Node:
		scene_to_remove.queue_free()

func ProgressRooms(scene_to_remove = null):
	
	if not CurrentAreaIndex < 3:
		print("CONGRADULATIONS YOU FOUND ALL 7 NOTEBOOKS!!!!!!!!!!!!!!!!!!!!?!?!")
	if CurrentRoomIndex == len(WorldDictionary.values()[CurrentAreaIndex]) - 1:
		CurrentAreaIndex += 1
		CurrentRoomIndex = 0
	else:
		CurrentRoomIndex += 1
	
	var room = WorldDictionary.values()[CurrentAreaIndex][CurrentRoomIndex].instantiate()
	get_tree().root.add_child(room)
	CurrentRoomScene = room
	
	if scene_to_remove is Node:
		scene_to_remove.queue_free()

## @deprecated
func FrameFreeze(duration : float, fps : int):
	Engine.time_scale = fps / 60.0
	Engine.physics_ticks_per_second = fps
	await get_tree().create_timer(duration * (fps / 60.0)).timeout
	Engine.physics_ticks_per_second = fps
	Engine.time_scale = 1
