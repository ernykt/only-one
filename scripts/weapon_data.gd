# weapon_data.gd (Resource)
extends Resource
class_name WeaponData

@export_group("Visuals")
@export var projectile_scene: PackedScene
@export var weapon_name: String
@export var animated_sprite: SpriteFrames

@export_group("Stats")
@export var damage: int = 10
@export var fire_rate: float = 0.5
@export var recoil_magnitude: float = 25.0

@export_group("Special Abilities")
@export var effects: Array[WeaponEffect] # Bileşen listesi
