extends Node

var DEBUG_MODE = true

# Statistics
var DamageDealt : int = 0
var DamageTaken : int = 0
var EnemiesDefeated : int = 0

var MusicVolume

const LOBBY = preload("res://Scenes/Lobby.tscn")

const GAME_END = preload("res://Scenes/Menus/Game End Menu/Game End.tscn")

const PROGRESS = preload("res://Scenes/Menus/ProgressScene.tscn")

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

const FLOWEYE_FIGHT = preload("res://Scenes/Bossfights/Floweye/FloweyeFight.tscn")
const MOUNTAIN_GUARDIAN_FIGHT = preload("res://Scenes/Bossfights/Mountain Guardian/Mountain Guardian Fight.tscn")
const ANCIENT_CORE_FIGHT = preload("res://Scenes/Bossfights/Ancient Core/Ancient Core Fight.tscn")

var AreaLevelCount : int = 3

var Areas : Dictionary = {
	"Area1" : Area1,
	"Area2" : Area2,
	"Area3" : Area3
}

var AreaMusicList = [
	preload("res://Music/FloweringSeaStacks.mp3"),
	preload("res://Music/TheSnowstormBelowTheWorld.mp3"),
	preload("res://Music/FinalAscent.mp3")
]

const LOST_AND_NOT_FORGOTTEN = preload("res://Music/Lost and not Forgotten.mp3")
const ATOP_THE_WORLD = preload("res://Music/Atop the World.mp3")

const LEECH_FLOWER = preload("res://Music/LeechFlower.mp3")
const ANGEL_GUARDIAN = preload("res://Music/AngelGuardian.mp3")
const PENULTIMATUM = preload("res://Music/Penultimatum.mp3")

var WorldDictionary : Dictionary = {}
var AreaArray : Array

var CurrentRoomIndex : int
var CurrentAreaIndex : int
var CurrentRoomScene : Node

@onready var MusicPlayer = AudioStreamPlayer.new()
var EndedGame : bool = false

func _ready():
	add_child(MusicPlayer)

func _input(event):
	if Input.is_action_just_pressed("Fullscreen"):
		print("FULLSCREEN SWAP")
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

		

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
		
		if area == 0:
			WorldDictionary[area][AreaLevelCount] = FLOWEYE_FIGHT
		if area == 1:
			WorldDictionary[area][AreaLevelCount] = MOUNTAIN_GUARDIAN_FIGHT
		if area == 2:
			WorldDictionary[area][AreaLevelCount] = ANCIENT_CORE_FIGHT
	
	print(WorldDictionary)

func StartGame(scene_to_remove = null):
	GenerateRooms()
	
	EndedGame = false
	MusicVolume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	MusicPlayer.volume_db = MusicVolume
	
	CurrentAreaIndex = 2
	CurrentRoomIndex = 2
	
	var room = WorldDictionary.values()[CurrentAreaIndex][CurrentRoomIndex].instantiate()
	get_tree().root.add_child(room)
	
	MusicPlayer.stream = AreaMusicList[CurrentAreaIndex]
	MusicPlayer.bus = "Music"
	MusicPlayer.play()
	
	if scene_to_remove is Node:
		scene_to_remove.queue_free()

var ProgressingRooms : bool = false
var ProgressingNotToEnd : bool = false

func ProgressRooms(scene_to_remove = null, IsEnd = false):
	
	print("PROGRESS!")
	
	if EndedGame:
		print("NO PROGRESS: ALREADY ENDED")
		return
	
	if ProgressingRooms:
		print("NO PROGRESS: ALREADY PROGRESSING")
		return
	
	ProgressingRooms = true
	ProgressingNotToEnd = true
	
	print("CURRENT AREA INDEX: " + str(CurrentAreaIndex))
	
	if CurrentAreaIndex == 2 and IsEnd:
		ProgressingNotToEnd = false
		EndGame(scene_to_remove, true)
	
	else:
		
		var progress = PROGRESS.instantiate()
		progress.global_position = Vector2(-progress.size.x-320, (-320/2))
		get_tree().root.add_child(progress)
		progress.z_index = 4
		progress.start()
		
		await progress.Closed
		
		var Stream = MusicPlayer.stream
		
		if scene_to_remove is Node:
			scene_to_remove.queue_free()
		
		if CurrentRoomIndex == len(WorldDictionary.values()[CurrentAreaIndex]) - 1:
			CurrentAreaIndex += 1
			CurrentRoomIndex = 0
			Stream = AreaMusicList[CurrentAreaIndex]
		else:
			CurrentRoomIndex += 1
		
		if CurrentRoomIndex == AreaLevelCount:
				if CurrentAreaIndex == 0:
					Stream = LEECH_FLOWER
				if CurrentAreaIndex == 1:
					Stream = ANGEL_GUARDIAN
				if CurrentAreaIndex == 2:
					Stream = PENULTIMATUM
		
		var room = WorldDictionary.values()[CurrentAreaIndex][CurrentRoomIndex].instantiate()
		get_tree().root.add_child(room)
		CurrentRoomScene = room
		
		if Stream != MusicPlayer.stream:
			var tween : Tween = create_tween()
			tween.tween_property(MusicPlayer, "volume_db", -80, 1)
			await tween.finished
			MusicPlayer.stream = Stream
			MusicPlayer.volume_db = MusicVolume
			MusicPlayer.play()
			progress.end()
		else:
			await get_tree().create_timer(1).timeout
			progress.end()
		
	ProgressingRooms = false
	ProgressingNotToEnd = false

func ResetGame(scene_to_remove = null, progress = null):
	
	var lobby = LOBBY.instantiate()
	get_tree().root.add_child(lobby)
	if scene_to_remove is Node:
		scene_to_remove.queue_free()
	
	if progress:
		progress.end()

func EndGame(scene_to_remove = null, Won : bool = false):
	
	print("ENDING GAME TRY")
	
	if ProgressingNotToEnd: return
	if EndedGame: return
	
	print("ENDING GAME")
	
	EndedGame = true
	var progress = PROGRESS.instantiate()
	progress.global_position = Vector2(-progress.size.x-320, (-320/2))
	get_tree().root.add_child(progress)
	progress.z_index = 4
	progress.start()
	
	await progress.Closed
	
	if scene_to_remove is Node:
		scene_to_remove.queue_free()
	
	if MusicPlayer.stream:
		var tween : Tween = create_tween()
		tween.tween_property(MusicPlayer, "volume_db", -80, 1)
		await tween.finished
		if Won: MusicPlayer.stream = ATOP_THE_WORLD
		else: MusicPlayer.stream = LOST_AND_NOT_FORGOTTEN
		MusicPlayer.volume_db = MusicVolume
		MusicPlayer.play()
		progress.end()
		progress.global_position = Vector2(progress.position.x, 0)
	else:
		if Won: MusicPlayer.stream = ATOP_THE_WORLD
		else: MusicPlayer.stream = LOST_AND_NOT_FORGOTTEN
		MusicPlayer.volume_db = MusicVolume
		MusicPlayer.play()
		await get_tree().create_timer(1).timeout
		progress.end()
		progress.global_position = Vector2(progress.position.x, 0)
	
	var GameEnd = GAME_END.instantiate()
	GameEnd.position = Vector2(0, 0)
	get_tree().root.add_child(GameEnd)
	GameEnd.enter(Won)

## @deprecated
func FrameFreeze(duration : float, fps : int):
	Engine.time_scale = fps / 60.0
	Engine.physics_ticks_per_second = fps
	await get_tree().create_timer(duration * (fps / 60.0)).timeout
	Engine.physics_ticks_per_second = fps
	Engine.time_scale = 1

func InstatiateEnemy(enemy : Enemy):
	pass
