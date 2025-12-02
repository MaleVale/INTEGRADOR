extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var is_attacking: bool = false

func _ready() -> void:
	anim.play("Idle")  # Que arranque en Idle

# Esta es la señal que ya tenías conectada
func _on_body_entered(body: Node2D) -> void:
	if is_attacking:
		return  # evita que se dispare dos veces

	if body.name == "Player":  # cambiá "Player" si tu nodo se llama distinto
		is_attacking = true

		# 1) Reproducir animación de ataque
		anim.play("Attack")

		# 2) (Opcional) dejar de detectar más cosas mientras ataca
		set_deferred("monitoring", false)

		# 3) Esperar un toque para que se vea el ataque
		var attack_duration: float = 0.4  # probá 0.3 / 0.5 según lo que dure tu anim
		await get_tree().create_timer(attack_duration).timeout

		# 4) "Matar" al player: reiniciar escena
		get_tree().reload_current_scene()
