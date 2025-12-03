extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_gold"):
		body.add_gold(1) 
		queue_free()
