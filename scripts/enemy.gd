extends CharacterBody2D

@onready var health_bar: ProgressBar = $HealthBar
@onready var player: Player = $"../Player"
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var health: int = 500
var speed: float = 150.0
var current_state: State = State.FOLLOW
var last_state: State = State.FOLLOW
var distance_between_player: float = 0.0
var direction_vector: Vector2 = Vector2.ZERO

enum State { FOLLOW, ATTACK, MISSILE, CRAZY }

func _ready() -> void:
	health_bar.value = health

func take_damage(damage: int):
	health -= damage
	health_bar.value -= damage

func _process(delta: float) -> void:
	handle_sprite_direction()
	distance_between_player = position.distance_to(player.position)
	match current_state:
		State.FOLLOW:
			follow_state()
		State.ATTACK:
			attack_state()
		State.MISSILE:
			pass
		State.CRAZY:
			pass
	move_and_slide()

func change_state(new_state: State):
	if current_state == new_state:
		return
	last_state = current_state
	current_state = new_state
	match current_state:
		State.FOLLOW:
			sprite_2d.play("Follow")
		State.ATTACK:
			pass
			#sprite_2d.play("Attack")

func follow_state():
	if distance_between_player <= 600.0:
		velocity = Vector2.ZERO
		change_state(State.ATTACK)
		return
	direction_vector = position.direction_to(player.position)
	velocity = direction_vector * speed
	
func attack_state():
	velocity = velocity.lerp(Vector2.ZERO, 0.2)
	if distance_between_player >= 600:
		change_state(State.FOLLOW)

func handle_sprite_direction():
	if direction_vector.x <= 0:
		sprite_2d.flip_h = false
	elif direction_vector.x >= 0:
		sprite_2d.flip_h = true
