extends CharacterBody2D

const player_sprite_frames = preload("res://resources/sprite_frames/player_sprite_frames.tres")
const shadow_sprite_frames = preload("res://resources/sprite_frames/shadow_sprite_frames.tres")

@onready var sprite : AnimatedSprite2D = %AnimatedSprite2D
@export var movement_speed : float = 500
var character_direction : Vector2


func _ready():
	ModeManager.player = self


func _physics_process(_delta):
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	character_direction = character_direction.normalized()
	
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x > global_position.x: sprite.flip_h = false
	else: sprite.flip_h = true
	
	#if character_direction.x > 0: sprite.flip_h = false
	#elif character_direction.x < 0: sprite.flip_h = true
	
	if character_direction:
		velocity = character_direction * movement_speed
		if sprite.animation != 'walk_lantern': sprite.animation = 'walk_lantern'
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		if sprite.animation != 'idle_lantern': sprite.animation = 'idle_lantern'
	
	move_and_slide()


func change_mode(mode : Enums.Gamemode):
	var current_anim = sprite.animation
	
	if mode == Enums.Gamemode.NORMAL:
		sprite.sprite_frames = player_sprite_frames
	elif mode == Enums.Gamemode.SHADOW:
		sprite.sprite_frames = shadow_sprite_frames
		print(sprite.animation)
	
	sprite.play(current_anim)
