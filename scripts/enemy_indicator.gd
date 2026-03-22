extends Sprite2D

var enemy: CharacterBody2D
var margin: float = 20.0

func _process(_delta):
	if not is_instance_valid(enemy) or enemy.is_dead:
		queue_free()
		return

	var screen_rect = get_viewport_rect()
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = screen_rect.size / canvas.get_scale()
	var center = top_left + size / 2

	var enemy_pos = enemy.global_position
	
	if screen_rect.has_point(get_viewport().get_camera_2d().get_screen_center_position() + (enemy_pos - get_viewport().get_camera_2d().get_screen_center_position())):
		visible = false
	else:
		visible = true
		
		var direction = (enemy_pos - center).normalized()
		global_position.x = clamp(center.x + direction.x * size.x, top_left.x + margin, top_left.x + size.x - margin)
		global_position.y = clamp(center.y + direction.y * size.y, top_left.y + margin, top_left.y + size.y - margin)
		
		look_at(enemy_pos)
