extends CharacterBody2D

var Direction : Vector2
@onready var animations = $Animations

var IdleAnimations : Dictionary = {
	Vector2(-1, 1) : { "Anim" : "Idle", "Flip" : false},
	Vector2(-1, 0) : { "Anim" : "IdleSide", "Flip" : false},
	Vector2(-1, -1) : { "Anim" : "IdleBack", "Flip" : false},
	Vector2(0, -1) : { "Anim" : "IdleUp", "Flip" : false},
	Vector2(1, -1) : { "Anim" : "IdleBack", "Flip" : true},
	Vector2(1, 0) : { "Anim" : "IdleSide", "Flip" : true},
	Vector2(1, 1) : { "Anim" : "Idle", "Flip" : true},
	Vector2(0, 1) : { "Anim" : "IdleForward", "Flip" : false}
}
var SlamAnimations : Dictionary = {
	Vector2(-1, 1) : { "Anim" : "Slam", "Flip" : false},
	Vector2(-1, 0) : { "Anim" : "SlamSide", "Flip" : false},
	Vector2(-1, -1) : { "Anim" : "SlamBack", "Flip" : false},
	Vector2(0, -1) : { "Anim" : "SlamUp", "Flip" : false},
	Vector2(1, -1) : { "Anim" : "SlamBack", "Flip" : true},
	Vector2(1, 0) : { "Anim" : "SlamSide", "Flip" : true},
	Vector2(1, 1) : { "Anim" : "Slam", "Flip" : true},
	Vector2(0, 1) : { "Anim" : "SlamForward", "Flip" : false}
}
var UpAnimations : Dictionary = {
	Vector2(-1, 1) : { "Anim" : "Up", "Flip" : false},
	Vector2(-1, 0) : { "Anim" : "UpSide", "Flip" : false},
	Vector2(-1, -1) : { "Anim" : "UpBack", "Flip" : false},
	Vector2(0, -1) : { "Anim" : "UpUp", "Flip" : false},
	Vector2(1, -1) : { "Anim" : "UpBack", "Flip" : true},
	Vector2(1, 0) : { "Anim" : "UpSide", "Flip" : true},
	Vector2(1, 1) : { "Anim" : "Up", "Flip" : true},
	Vector2(0, 1) : { "Anim" : "UpForward", "Flip" : false}
}
