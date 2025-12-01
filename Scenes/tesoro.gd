extends AnimatedSprite2D

var abierto := false

func reproducir_animacion():
	if not abierto:
		abierto = true
		play("default")
