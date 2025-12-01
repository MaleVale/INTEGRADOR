extends Area2D

@export var bullet_scene: PackedScene
@export var shoot_interval: float = 1.2

var player_in_range: bool = false
var player_ref: Node2D = null

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_bullet: Marker2D = $SpawnBullet
@onready var shoot_timer: Timer = $ShootTimer

func _ready() -> void:
	anim.play("idle")
	shoot_timer.wait_time = shoot_interval

func _physics_process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().reload_current_scene()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = true
		player_ref = body
		anim.play("attack")
		shoot_timer.start()

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = false
		player_ref = null
		shoot_timer.stop()
		anim.play("idle")

func _on_shoot_timer_timeout() -> void:
	if not player_in_range:
		return
	if bullet_scene == null:
		return
	if player_ref == null:
		return

	var bullet := bullet_scene.instantiate()
	bullet.global_position = spawn_bullet.global_position

	if player_ref.global_position.x < global_position.x:
		bullet.direction = Vector2.LEFT
	else:
		bullet.direction = Vector2.RIGHT

	get_tree().current_scene.add_child(bullet)
