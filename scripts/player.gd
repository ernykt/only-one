extends CharacterBody2D
class_name Player

@onready var weapon_holder: Marker2D = $WeaponHolder
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cool_down: Timer = $DashCoolDown
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

enum State { IDLE, MOVE, DASH }

var speed = 300.0
var current_state: State = State.IDLE
var last_state: State = State.IDLE
var dash_speed: int = 900
var dash_direction = Vector2.ZERO
var can_dash: bool = true

func _physics_process(_delta: float) -> void:
	match current_state:
		State.IDLE:
			idle_state()
		State.MOVE:
			move_state()
		State.DASH:
			dash_state()
	handle_shooting()
	move_and_slide()

func get_movement_direction() -> Vector2:
	return Input.get_vector("move left", "move right", "move up", "move down")

func change_state(new_state: State):
	if current_state == new_state:
		return
	last_state = current_state
	current_state = new_state

func handle_shooting():
	if Input.is_action_pressed("shoot"):
		sprite_2d.flip_h = false
		for child in weapon_holder.get_children():
			if child is Weapon and child.visible:
				child.shoot(self)

func move_state():
	handle_sprite_direction()
	sprite_2d.play("Move")
	var dir = get_movement_direction()

	if dir == Vector2.ZERO:
		change_state(State.IDLE)
		return
	if Input.is_action_just_pressed("Dash") and can_dash:
		dash_timer.start(.5)
		change_state(State.DASH)

	velocity = dir * speed

func idle_state():
	sprite_2d.play("Idle")
	var dir = get_movement_direction()
	
	if dir != Vector2.ZERO:
		change_state(State.MOVE)
		return
	if Input.is_action_just_pressed("Dash") and can_dash:
		dash_timer.start(.5)
		change_state(State.DASH)
	velocity = velocity.lerp(Vector2.ZERO, 0.2)
	
func dash_state():
	if dash_timer.time_left <= 0:
		change_state(State.IDLE)
	if can_dash:
		sprite_2d.play("Dash")
		can_dash = false
		dash_cool_down.start(1.5)
		dash_direction = global_position.direction_to(get_global_mouse_position()).normalized()
		if dash_direction.x <= 0:
			sprite_2d.flip_h = true
		velocity = dash_direction * dash_speed
		
func _on_dash_cool_down_timeout() -> void:
	can_dash = true

func handle_sprite_direction():
	var dir = get_movement_direction()
	if dir == Vector2.LEFT:
		sprite_2d.flip_h = true
	if dir == Vector2.RIGHT:
		sprite_2d.flip_h = false
