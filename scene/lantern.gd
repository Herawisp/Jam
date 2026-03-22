extends Area2D

@onready var light = %PointLight2D
@onready var sprite = %Sprite2D

@export var minimum_scale = 2
@export var scale_decrease_rate = 0.001
@export var friction = 0.05

var velocity = Vector2.ZERO
var pickupable = false
var thrown = false

func _ready() -> void:
	sprite.visible = false


func _physics_process(delta):
	position += velocity * delta
	velocity = velocity.lerp(Vector2.ZERO, friction)
	
	if velocity.length() < 2:
		if thrown:
			pickupable = true
			thrown = false
		velocity = Vector2.ZERO


func _process(delta: float) -> void:
	if light.texture_scale <= minimum_scale: return
	light.texture_scale -= scale_decrease_rate


func enable_sprite():
	sprite.visible = not sprite.visible


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and pickupable:
		body.attach_lantern() 
