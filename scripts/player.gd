extends CharacterBody2D
class_name Player

const bullet = preload("res://scenes/bullet.tscn")
@onready var gun: Node2D = $Gun
@onready var gun_animation_node = get_node("Gun").get_child(0)

const SPEED = 300.0

func _physics_process(_delta: float) -> void:
	get_input()
	if Input.is_action_just_pressed("shoot"):
		if (gun_animation_node.is_playing() and !gun_animation_node.animation == "Idle" ):	return
		gun_animation_node.play("Fire")
		shoot()

	move_and_slide()

func get_input():
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.lerp(Vector2.ZERO, 0.25)

func shoot():
	var gun_marker = get_node("Gun").get_child(1)
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = gun_marker.global_position
	bullet_instance.rotation = gun_marker.global_rotation
	get_parent().add_child(bullet_instance)

func _on_animated_sprite_2d_animation_finished() -> void:
	print("test")
