extends CharacterBody2D

const player_sprite_frames = preload("res://resources/sprite_frames/player_sprite_frames.tres")
const shadow_sprite_frames = preload("res://resources/sprite_frames/shadow_sprite_frames.tres")

@onready var texture_progress_bar : TextureProgressBar = %TextureProgressBar
@onready var sprite : AnimatedSprite2D = %AnimatedSprite2D
@onready var lanternFollow = %LanternFollow
@onready var lantern = %Lantern
@onready var gun = %Gun
@onready var sword = %Sword

@export var movement_speed : float = 300
@export var throw_force = 1000
var character_direction : Vector2
var lantern_attached = true

var max_health = 100
var health = 100

func _ready():
	texture_progress_bar.min_value = 0
	texture_progress_bar.max_value = max_health
	ModeManager.player = self


func _input(event):
	if event.is_action_pressed("change_weapon"):
		change_weapon()
	elif event.is_action_pressed("throw_lantern"):
		throw_lantern()


func _physics_process(_delta):
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	character_direction = character_direction.normalized()
	
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x > global_position.x: sprite.flip_h = false
	else: sprite.flip_h = true
	
	if character_direction:
		velocity = character_direction * movement_speed
		if lantern_attached:
			if sprite.animation != 'walk_lantern': sprite.animation = 'walk_lantern'
		else: if sprite.animation != 'walk_normal': sprite.animation = 'walk_normal'
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		if lantern_attached:
			if sprite.animation != 'idle_lantern': sprite.animation = 'idle_lantern'
		else: if sprite.animation != 'idle_normal': sprite.animation = 'idle_normal'
	
	move_and_slide()


func change_weapon():
	if gun.active:
		gun.trigger()
		sword.trigger()
	else:
		sword.trigger()
		gun.trigger()


func change_mode(mode : Enums.Gamemode):
	var current_anim = sprite.animation
	
	if mode == Enums.Gamemode.NORMAL:
		sprite.sprite_frames = player_sprite_frames
	elif mode == Enums.Gamemode.SHADOW:
		sprite.sprite_frames = shadow_sprite_frames
		print(sprite.animation)
	
	sprite.play(current_anim)


func throw_lantern():
	lanternFollow.update_position = false
	lantern.thrown = true
	lantern.enable_sprite()
	lantern_attached = false
	
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	lantern.velocity = direction * throw_force

func attach_lantern():
	lanternFollow.update_position = true
	lantern.enable_sprite()
	lantern_attached = true


func take_damage(amount: int):
	health -= amount
	flash_sprite()
	
	if health <= 0:
		die()
	texture_progress_bar.value = health


func flash_sprite():
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(10, 10, 10, 1), 0.05)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.1)


func die():
	get_tree().quit()


func _on_door_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
