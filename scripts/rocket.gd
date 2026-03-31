extends Area2D
class_name Rocket

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var sprite_2d_2: Sprite2D = $Sprite2D2

var travelSpeed = 150.0
signal hit_target(target: Node2D)
signal fired(rocket: Area2D)

func _ready() -> void:
	sprite_2d.visible = false
	fired.emit(self)

func _process(delta: float) -> void:
	position += transform.x * travelSpeed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()

func _on_body_entered(body: Node2D) -> void:
	set_process(false)
	hit_target.emit(body)
	sprite_2d.visible = true
	sprite_2d_2.visible = false
	sprite_2d.play("Explosion")

func _on_explosion_timer_timeout() -> void:
	set_process(false)
	sprite_2d.visible = true
	sprite_2d_2.visible = false
	sprite_2d.play("Explosion")

func _on_sprite_2d_animation_finished() -> void:
	self.queue_free()
