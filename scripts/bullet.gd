extends Area2D

var travelSpeed = 700.0
signal hit_target(target: Node2D)

func _process(delta: float) -> void:
	position += transform.x * travelSpeed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		hit_target.emit(body)
