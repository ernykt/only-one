extends Node2D

@onready var player: Player = $Player
@onready var color_rect: ColorRect = $ColorRect

#set_physics_process(false)

var is_player_dead: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.current_state == player.State.DEATH:
		if not is_player_dead:
			print("test")
			is_player_dead = true
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tween.tween_property(color_rect, "modulate:a", 1, 1)
		
