extends Node2D

@onready var sprite = %AnimatedSprite2D
@onready var cooldown = %Cooldown

@export var horizontal_radius: float = 35.0 
@export var vertical_radius: float = 55.0

var offset_vector = Vector2(0, 25)
var index = 1
var active = true
var slashing = false
var can_attack = true

func _input(event):
	if event.is_action_pressed("shoot") and active:
		shoot()


func _process(_delta):
	update_transform()


func trigger():
	active = not active
	visible = not visible


func shoot():
	if not can_attack: return
	can_attack = false
	cooldown.start()
	
	if index % 3 != 0:
		sprite.play("slash")
		slashing = true
	else:
		sprite.play("strike")
		slashing = true
	index += 1


func update_transform():
	var mouse_pos = get_global_mouse_position()
	var parent_position = get_parent().global_position + offset_vector
	var direction = (mouse_pos - parent_position).normalized()

	var orbit_offset = Vector2(
		direction.x * horizontal_radius,
		direction.y * vertical_radius
	)
	
	position = orbit_offset + offset_vector
	look_at(mouse_pos)
	scale.y = (-1 if mouse_pos.x < parent_position.x else 1) * (-1 if index % 2 == 0 else 1)


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation != "idle":
		sprite.play("idle")
		await get_tree().create_timer(.5).timeout
		slashing = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if index % 3 != 0 and slashing:
		if area.is_in_group('Projectile'):
			area.rotation_degrees += 180


func _on_cooldown_timeout() -> void:
	can_attack = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(slashing)
	if body.name == "Wizard" and slashing:
		body.take_damage(5)
