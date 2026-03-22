extends Area2D

@onready var enemies = %Enemies

func is_enemies_dead():
	var enemy_count = enemies.get_child_count()
	return true if enemy_count <= 0 else false
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and is_enemies_dead():
		get_tree().change_scene_to_file("res://scene/levels/Boss_Map.tscn")
