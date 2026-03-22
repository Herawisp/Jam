extends Area2D

@export var speed: float = 500.0
@export var damage: int = 5
var target_group : String = 'None'

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if not "health" in body:
		queue_free()
		return
	
	if body.is_in_group(target_group):
		body.take_damage(15)
		queue_free()
