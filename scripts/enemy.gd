extends CharacterBody2D
class_name Boss

@onready var health_bar: ProgressBar = $HealthBar
@onready var player: Player = $"../Player"
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var boss_weapon: Node2D = $BossWeapon
@onready var boss_bazooka: Node2D = $BossBazooka
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var attack_timer: Timer = $AttackTimer

var health: int = 500
var speed: float = 150.0
var rage_attack_speed: float = 900.0
var current_state: State = State.RAGE
var last_state: State = State.FOLLOW
var distance_between_player: float = 0.0
var direction_vector: Vector2 = Vector2.ZERO
var follow_distance: float = 1500.0
var can_attack: bool = true

enum State { FOLLOW, ATTACK, MISSILE, RAGE, DEATH}

func _ready() -> void:
	health_bar.value = health

func take_damage(damage: int):
	health -= damage
	health_bar.value -= damage
	flash_damage()

func _process(delta: float) -> void:
	print(attack_timer.time_left)
	handle_sprite_direction()
	if player:
		distance_between_player = position.distance_to(player.position)
	match current_state:
		State.FOLLOW:
			follow_state()
		State.ATTACK:
			attack_state()
		State.DEATH:
			death_state()
		State.RAGE:
			rage_state()
		State.MISSILE:
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
			sprite_2d.play("Idle")
		State.DEATH:
			sprite_2d.play("Die")
		State.RAGE:
			attack_timer.start(1.5)
			sprite_2d.play("Rage")

func follow_state():
	if health <= 0:
		change_state(State.DEATH)
	if distance_between_player <= follow_distance:
		velocity = Vector2.ZERO
		change_state(State.ATTACK)
		return
	if player:
		direction_vector = position.direction_to(player.position)
	velocity = direction_vector * speed
	
func attack_state():
	velocity = velocity.lerp(Vector2.ZERO, 0.2)
	if health <= 0:
		change_state(State.DEATH)
	if distance_between_player >= follow_distance:
		change_state(State.FOLLOW)
		
func rage_state():
	if health <= 0:
		change_state(State.DEATH)
	global_position = global_position.lerp(player.position, 0.025)
	if global_position.distance_to(player.position) <= 255.0 and not sprite_2d.is_playing():
		change_state(State.FOLLOW)
		
func death_state():
	velocity = velocity.lerp(Vector2.ZERO, 0.2)
	boss_weapon.visible = false
	boss_bazooka.visible = false
	health_bar.visible = false
	area_2d.disable_mode
	collision_shape_2d.disabled = true
		
func flash_damage():
	var tween = create_tween()
	sprite_2d.modulate = Color(15, 15, 15) 
	tween.tween_property(sprite_2d, "modulate", Color.WHITE, 0.08)

func handle_sprite_direction():
	if direction_vector.x <= 0:
		sprite_2d.flip_h = false
	elif direction_vector.x >= 0:
		sprite_2d.flip_h = true
		
func _on_attack_timer_timeout() -> void:
	can_attack = true
