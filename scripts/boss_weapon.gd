extends Node2D

@export var data: WeaponData
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var owner_node = get_parent()
@onready var marker_2d: Marker2D = $Marker2D
@onready var boss = get_parent()

var recoil: float

func _ready():
	weapon_setup()
	if data:
		animated_sprite.sprite_frames = data.animated_sprite

func shoot():
	if animated_sprite.is_playing() and animated_sprite.animation == "Fire":
		return
	
	animated_sprite.play("Fire")

	var pellet_count: int = 6
	var spread_angle: float = 30.0
	
	for i in range(pellet_count):
		var bullet_instance = data.projectile_scene.instantiate()
		if bullet_instance.has_signal("hit_target"):
			bullet_instance.hit_target.connect(_on_projectile_impact)
			
		get_tree().current_scene.add_child(bullet_instance)
		
		bullet_instance.global_position = marker_2d.global_position
		
		var random_spread = randf_range(-spread_angle / 2, spread_angle / 2)
		bullet_instance.global_rotation = marker_2d.global_rotation + deg_to_rad(random_spread)
		
		bullet_instance.global_position.y += randf_range(-data.recoil_magnitude, data.recoil_magnitude)
		
		
func _process(_delta: float) -> void:
	if boss.player:
		if boss.current_state == boss.State.ATTACK:
			if not boss.player.current_state == boss.player.State.DEATH:
				shoot()
		look_at(boss.player.global_position)
	rotation_degrees = posmod(rotation_degrees, 360.0)
	if rotation_degrees > 90 and rotation_degrees < 270:
		animated_sprite.flip_v = true
	else:
		animated_sprite.flip_v = false

func weapon_setup():
	animated_sprite.speed_scale = data.fire_rate

func _on_projectile_impact(body : Node):
	for effect in data.effects:
		effect.on_hit(body, owner_node, data.damage)
