extends Node2D

@export var data: WeaponData
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var owner_node = get_parent()
@onready var bazooka_marker: Marker2D = $BazookaMarker
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
	
	var rocket_instance = data.projectile_scene.instantiate()
	if rocket_instance.has_signal("hit_target"):
		rocket_instance.hit_target.connect(_on_projectile_impact)
		rocket_instance.fired.connect(_on_projectile_fired)
	rocket_instance.global_position = bazooka_marker.global_position
	rocket_instance.global_rotation = bazooka_marker.global_rotation
	get_tree().current_scene.add_child(rocket_instance)
		
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
		
func _on_projectile_fired(rocket):
	for effect in data.effects:
		effect.on_shoot(rocket)
