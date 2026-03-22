extends CharacterBody2D

const projectile = preload("res://scene/projectile.tscn")

@export var speed: float = 200.0
@export var max_dist: float = 300.0
@export var min_dist: float = 150.0 
@export var stop_dist: float = 100.0
@export var aggro_range: float = 500.0 

@onready var player = %Player
@onready var attack_timer = %AttackTimer
@onready var sprite = %AnimatedSprite2D
@onready var shoot_point = %ShootPoint

var is_dead: bool = false
var can_attack: bool = true
var target : String = 'Enemy'

var max_health = 100
var health = 100

func _physics_process(_delta):
	if is_dead or not player:
		return

	var distance = global_position.distance_to(player.global_position)
	var direction = global_position.direction_to(player.global_position)

	if distance < aggro_range:
		if distance > max_dist:
			velocity = direction * speed
			if sprite.animation != "walk": sprite.play("walk")
		elif distance < stop_dist:
			velocity = -direction * speed
			if sprite.animation != "walk": sprite.play("walk")
		else:
			velocity = Vector2.ZERO
			if sprite.animation != "idle": sprite.play("idle")
			if can_attack:
				attack()
		
		shoot_point.look_at(player.global_position)
		sprite.flip_h = direction.x < 0
	else:
		velocity = Vector2.ZERO
		if sprite.animation != "idle": sprite.play("idle")

	move_and_slide()


func attack():
	can_attack = false
	attack_timer.start()


func take_damage(amount: int):
	health -= amount
	flash_sprite()
	
	if health <= 0:
		die()


func flash_sprite():
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(10, 10, 10, 1), 0.05)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.1)


func die():
	if is_dead: return
	is_dead = true
	attack_timer.stop()
	velocity = Vector2.ZERO
	can_attack = false
	sprite.play("death")


func _on_attack_timer_timeout() -> void:
	can_attack = true
	var bullet = projectile.instantiate()
	bullet.target_group = 'Player'
	bullet.global_position = shoot_point.global_position
	bullet.rotation = shoot_point.rotation
	get_tree().root.add_child(bullet)


func _on_animated_sprite_2d_animation_looped() -> void:
	if sprite.animation == "death":
		queue_free()
