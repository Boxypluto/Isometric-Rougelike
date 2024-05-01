extends Node2D

# Player
@onready var player : CharacterBody2D = $"../../Player"

@onready var tele_1 : Area2D = $Tele1
@onready var tele_2 : Area2D = $Tele2

@onready var animation_1 = $Tele1/Animation1
@onready var animation_2 = $Tele2/Animation2

# Audio Stream
@onready var blink = $Blink

var teleporting : bool = false

func TeleOneEntered(HitBox : HurtBoxComponent):
	if not teleporting: TeleporterEntered(HitBox, tele_2)

func TeleTwoEntered(HitBox : HurtBoxComponent):
	if not teleporting: TeleporterEntered(HitBox, tele_1)

func TeleporterEntered(HitBox : HurtBoxComponent, TeleTo : Area2D):
	blink.play()
	print("TO: " + TeleTo.name)
	teleporting = true
	animation_1.play("Off")
	animation_2.play("Off")
	player.global_position = TeleTo.global_position
	await get_tree().create_timer(1.5).timeout
	animation_1.play("On")
	animation_2.play("On")
	teleporting = false
