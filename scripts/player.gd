extends Area2D

@export var speed = 400.0
var screen_size

func _ready() -> void:
	screen_size = get_viewport().size
	
func _process(delta):
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
		$AnimatedSprite2D.play("walk")
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.play("idle")
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
