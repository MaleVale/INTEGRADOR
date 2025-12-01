extends CharacterBody2D

const SPEED := 200.0
const JUMP_VELOCITY := -400.0
const GRAVITY := 1200.0

func _physics_process(delta: float) -> void:
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Movimiento horizontal (teclas izquierda/derecha)
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Salto (ESPACIO / Enter por defecto con ui_accept)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()
