extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var travelSpeed = 600.0
signal hit_target(target: Node2D)
signal fired(rocket: Area2D)

func _ready() -> void:
	fired.emit(self)

func _process(delta: float) -> void:
	position += transform.x * travelSpeed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.is_in_group("enemy"):
		hit_target.emit(body)
		self.queue_free()
