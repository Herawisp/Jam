extends Node2D

@onready var sprite = %AnimatedSprite2D
@onready var cooldown = %Cooldown
@onready var hitbox = %Area2D

@export var horizontal_radius: float = 35.0 
@export var vertical_radius: float = 55.0

var offset_vector = Vector2(0, 25)
var index: int = 1
var active: bool = false
var slashing: bool = false
var can_attack: bool = true

func _input(event):
	if event.is_action_pressed("shoot") and active:
		shoot()

func _process(_delta):
	if active:
		update_transform()

func trigger():
	active = !active
	visible = active

func shoot():
	if not can_attack: return
	
	can_attack = false
	slashing = true
	cooldown.start()
	
	var anim_name = "strike" if index % 3 == 0 else "slash"
	sprite.play(anim_name)
	index += 1
	
	var bodies = hitbox.get_overlapping_bodies()
	print(bodies)
	for body in bodies:
		if body.is_in_group("Enemy") and body.has_method("take_damage"):
			body.take_damage(5)

func update_transform():
	var mouse_pos = get_global_mouse_position()
	var parent_pos = get_parent().global_position + offset_vector
	var direction = (mouse_pos - parent_pos).normalized()

	var orbit_offset = Vector2(direction.x * horizontal_radius, direction.y * vertical_radius)
	global_position = parent_pos + orbit_offset
	
	look_at(mouse_pos)
	
	var flip_dir = -1 if mouse_pos.x < parent_pos.x else 1
	var combo_flip = -1 if index % 2 == 0 else 1
	scale.y = flip_dir * combo_flip

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation != "idle":
		sprite.play("idle")
		slashing = false

func _on_cooldown_timeout() -> void:
	can_attack = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if slashing and area.is_in_group("Projectile"):
		area.rotation_degrees += 180
