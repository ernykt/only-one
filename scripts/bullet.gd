extends Area2D

var travelSpeed = 700.0

func _process(delta: float) -> void:
	position += transform.x * travelSpeed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("bye bye")
	self.queue_free()
