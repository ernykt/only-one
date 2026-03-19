extends Node2D
class_name Weapon

@export var data: WeaponData
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var owner_node = get_parent()
@onready var marker_2d: Marker2D = $Marker2D

var recoil: float

func _ready():
	weapon_setup()
	if data:
		animated_sprite.sprite_frames = data.animated_sprite

func shoot(_target):
	if animated_sprite.is_playing() and not animated_sprite.animation == "Idle": return
	recoil = randf_range(marker_2d.global_position.y - data.recoil_magnitude, marker_2d.global_position.y + data.recoil_magnitude)
	animated_sprite.play("Fire")
	var bullet_instance = data.projectile_scene.instantiate()
	bullet_instance.hit_target.connect(_on_projectile_impact)
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.global_position.x = marker_2d.global_position.x
	bullet_instance.global_position.y = recoil
	bullet_instance.global_rotation = marker_2d.global_rotation
		
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	rotation_degrees = posmod(rotation_degrees, 360.0)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1

func weapon_setup():
	animated_sprite.speed_scale = data.fire_rate

func _on_animated_sprite_animation_finished() -> void:
	if animated_sprite.animation == "Fire":
		animated_sprite.play("Idle")

func _on_projectile_impact(body : Node):
	for effect in data.effects:
		effect.on_hit(body, owner_node, data.damage)
