extends Area2D

@export var speed = 400.0
var screen_size
var start_pos
var is_shadow = false
var is_throwing = false

func _ready() -> void:
	screen_size = get_viewport().size
	start_pos = position

func _process(delta):
	if is_throwing:
		return

	if Input.is_action_just_pressed("change"):
		is_shadow = !is_shadow

	if is_shadow and Input.is_action_just_pressed("throw"):
		lempar_lantern()
		return

	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_kanan"):
		velocity.x += 1
	if Input.is_action_pressed("move_kiri"):
		velocity.x -= 1
	if Input.is_action_pressed("move_bawah"):
		velocity.y += 1
	if Input.is_action_pressed("move_atas"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		if is_shadow:
			$AnimatedSprite2D.play("lantern")
		else:
			$AnimatedSprite2D.play("walk")
			
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.play("idle")
		
	position += velocity * delta

func lempar_lantern():
	is_throwing = true
	$AnimatedSprite2D.play("lantern-throw")
	await $AnimatedSprite2D.animation_finished
	is_throwing = false
