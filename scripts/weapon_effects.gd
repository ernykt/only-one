# weapon_effect.gd (Resource)
extends Resource
class_name WeaponEffect

func on_hit(target: Node, source: Node, damage: int):
	pass # Alt sınıflar burayı dolduracak (Burn, LifeSteal vb.)

func on_shoot(source: Node):
	pass
