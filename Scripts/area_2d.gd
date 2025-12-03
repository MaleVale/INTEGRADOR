extends Area2D

func _on_Area2D_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	# Solo se puede ganar si ya es la fase 2 (después del tesoro)
	# o, equivalentemente, si tiene la espada
	if not body.has_sword and not body.is_phase2:
		return

	if body.has_method("win_game"):
		body.win_game()
