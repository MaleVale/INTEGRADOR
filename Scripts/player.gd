extends CharacterBody2D

const SPEED := 200.0
const JUMP_VELOCITY := -400.0
const GRAVITY := 1200.0
const TRAMPOLINE_BOOST := -700.0

var on_ladder: bool = false
var has_key: bool = false

@onready var mensaje = get_parent().get_node("CanvasLayer/Mensaje")
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if anim == null:
		push_error("AnimatedSprite2D no encontrado en: %s" % name)
	else:
		print("Player OK, anim encontrado en: ", name)

func _physics_process(delta: float) -> void:
	if on_ladder:
		velocity.y = 0
		var climb_dir := Input.get_axis("ui_up", "ui_down")
		velocity.y = climb_dir * 150.0
		velocity.x = 0
		_update_animation()
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

	_update_animation()
	move_and_slide()

func _update_animation() -> void:
	if on_ladder:
		anim.play("Idle")
		return

	if not is_on_floor():
		anim.play("Jump")
		if velocity.x != 0:
			anim.flip_h = velocity.x < 0
		return

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		anim.play("Run")
		anim.flip_h = direction < 0
	else:
		anim.play("Idle")

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

func _on_agua_body_entered(body: Node2D) -> void:
	if body == self:
		get_tree().reload_current_scene()

func _on_llave_body_entered(body: Node2D) -> void:
	if body == self:
		has_key = true
		get_parent().get_node("Llave").queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		var tesoro = get_parent().get_node("Tesoro")
		if has_key:
			mensaje.text = "Encontraste el tesoro"
			tesoro.reproducir_animacion()
		else:
			mensaje.text = "Te falta la llave"
