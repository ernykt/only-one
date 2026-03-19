extends Node2D
class_name Weapons

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var marker_2d: Marker2D = $Marker2D

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	rotation_degrees = posmod(rotation_degrees, 360.0)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1

func _on_animated_sprite_2d_animation_finished() -> void:
	if (animated_sprite_2d.animation == "Fire"):
		animated_sprite_2d.play("Idle")
		
