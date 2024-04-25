extends Node

var DEBUG_MODE = true

var TestingRooms : Array = [
	preload("res://Scenes/Rooms/Room 1.tscn"),
	preload("res://Scenes/Rooms/Room 2.tscn"),
	preload("res://Scenes/Rooms/Room 3.tscn")
]

var Area1 : Array = [
	preload("res://Scenes/Areas/Area 1/Archipelago.tscn"),
	preload("res://Scenes/Areas/Area 1/AtopTheWall.tscn"),
	preload("res://Scenes/Areas/Area 1/GrassIslands.tscn")
]

var AreaLevelCount : int = 3

var Areas : Dictionary = {
	#"Testing" : TestingRooms,
	"Area1" : Area1
}

var WorldDictionary : Dictionary = {}
var AreaArray : Array

var CurrentRoomIndex : int
var CurrentAreaIndex : int

func GenerateRooms():
	
	WorldDictionary.clear()
	AreaArray.clear()
	
	for area in Areas:
		
		var AreaDictionary : Dictionary
		var LevelList : Array
		for scene in Area1:
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
	
	if CurrentRoomIndex == len(WorldDictionary.values()[CurrentAreaIndex]) - 1:
		CurrentRoomIndex = 0
	else:
		CurrentRoomIndex += 1
	
	var room = WorldDictionary.values()[CurrentAreaIndex][CurrentRoomIndex].instantiate()
	get_tree().root.add_child(room)
	
	if scene_to_remove is Node:
		scene_to_remove.queue_free()

## @deprecated
func FrameFreeze(duration : float, fps : int):
	Engine.time_scale = fps / 60.0
	Engine.physics_ticks_per_second = fps
	await get_tree().create_timer(duration * (fps / 60.0)).timeout
	Engine.physics_ticks_per_second = fps
	Engine.time_scale = 1
