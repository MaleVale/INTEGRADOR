extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var is_attacking: bool = false

func _ready() -> void:
	anim.play("Idle")

func _on_body_entered(body: Node2D) -> void:
	if is_attacking:
		return

	if body.name == "Player" and body.has_method("kill_player"):
		is_attacking = true
		anim.play("Attack")
		set_deferred("monitoring", false)
		body.kill_player()
