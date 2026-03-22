extends Node2D

const projectile = preload("res://scene/projectile.tscn")
@onready var shoot_point = %ShootPoint

@export var horizontal_radius: float = 55.0 
@export var vertical_radius: float = 65.0
var offset_vector = Vector2(0, 25)
var active = false

func _input(event):
	if event.is_action_pressed("shoot") and active:
		shoot()


func _process(_delta):
	update_gun_transform()


func shoot():
	var bullet = projectile.instantiate()
	bullet.global_position = shoot_point.global_position
	bullet.rotation = rotation
	get_tree().root.add_child(bullet)


func update_gun_transform():
	var mouse_pos = get_global_mouse_position()
	var parent_position = get_parent().global_position + offset_vector
	var direction = (mouse_pos - parent_position).normalized()

	var orbit_offset = Vector2(
		direction.x * horizontal_radius,
		direction.y * vertical_radius
	)
	
	position = orbit_offset + offset_vector
	look_at(mouse_pos)
	scale.y = -1 if mouse_pos.x < parent_position.x else 1
