extends Area2D

const SPEED := 300.0
var direction: Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.has_method("kill_player"):
		body.kill_player()
	call_deferred("queue_free")
