extends Node2D

# Player
@onready var player : CharacterBody2D = $"../../Player"

@onready var tele_1 : Area2D = $Tele1
@onready var tele_2 : Area2D = $Tele2

var teleporting : bool = false

func TeleOneEntered(HitBox : HurtBoxComponent):
	if not teleporting: TeleporterEntered(HitBox, tele_2)

func TeleTwoEntered(HitBox : HurtBoxComponent):
	if not teleporting: TeleporterEntered(HitBox, tele_1)

func TeleporterEntered(HitBox : HurtBoxComponent, TeleTo : Area2D):
	print("TO: " + TeleTo.name)
	teleporting = true
	player.global_position = TeleTo.global_position
	await get_tree().create_timer(0.1).timeout
	teleporting = false
