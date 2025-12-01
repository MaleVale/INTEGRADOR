extends CharacterBody2D

const SPEED := 200.0
const JUMP_VELOCITY := -400.0
const GRAVITY := 1200.0
const TRAMPOLINE_BOOST := -700.0

var on_ladder: bool = false

func _physics_process(delta: float) -> void:
	if on_ladder:
		velocity.y = 0
		var climb_dir := Input.get_axis("ui_up", "ui_down")
		velocity.y = climb_dir * 150.0
		velocity.x = 0
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()

func _on_cadena_aerea_body_entered(body: Node2D) -> void:
	if body == self:
		on_ladder = true
		velocity = Vector2.ZERO

func _on_cadena_aerea_body_exited(body: Node2D) -> void:
	if body == self:
		on_ladder = false

func _on_trampolin_area_body_entered(body: Node2D) -> void:
	if body == self and velocity.y > 0.0:
		on_ladder = false
		velocity.y = TRAMPOLINE_BOOST
