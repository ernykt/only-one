extends WeaponEffect
class_name RocketEffect

func on_hit(target: Node, source: Node, damage: int):
	target.flash_damage()
	target.health -= damage
	target.health_bar.value -= damage
	var push_direction = (target.global_position - source.global_position).normalized()
	var knockback_force = source.get_node("BossWeapon").data.knockback_force
	var target_destination = target.global_position + (push_direction * knockback_force)
	var tween = target.create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "global_position", target_destination, 0.2)
	
func on_shoot(source: Node):
	pass
