extends WeaponEffect
class_name BurnEffect

func on_hit(target_name: Node, source: Node, damage: int):
	target_name.take_damage(damage)
	target_name.flash_damage()
	
