extends Node2D

@onready var player : CharacterBody2D = null
@export var current_mode = Enums.Gamemode.NORMAL


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("change_mode") and player != null:
		change_mode()


func change_mode():
	if current_mode == Enums.Gamemode.NORMAL:
		current_mode = Enums.Gamemode.SHADOW
	elif current_mode == Enums.Gamemode.SHADOW:
		current_mode = Enums.Gamemode.NORMAL
	player.change_mode(current_mode)
