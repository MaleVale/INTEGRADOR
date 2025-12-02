extends CharacterBody2D

const SPEED := 200.0
const JUMP_VELOCITY := -400.0
const GRAVITY := 1200.0
const TRAMPOLINE_BOOST := -700.0

var on_ladder: bool = false
var has_key: bool = false
var has_sword: bool = false
var sword_spawned: bool = false
var is_attacking: bool = false
var is_dead: bool = false

@export var sword_scene: PackedScene

@onready var mensaje = get_parent().get_node("CanvasLayer/Mensaje")
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword_hitbox: Area2D = $SwordHitbox

func _physics_process(delta: float) -> void:
	if is_dead:
		return

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

	if has_sword and Input.is_action_just_pressed("attack"):
		is_attacking = true
		anim.play("Attack")

	_update_animation()

	if has_sword and is_attacking:
		_check_sword_hits()

	move_and_slide()

func _update_animation() -> void:
	if is_dead:
		return

	if is_attacking:
		return

	var idle_name = "Idle2" if has_sword else "Idle"
	var run_name = "Run2" if has_sword else "Run"
	var jump_name = "Jump2" if has_sword else "Jump"

	if on_ladder:
		anim.play(idle_name)
		return

	if not is_on_floor():
		anim.play(jump_name)
		if velocity.x != 0:
			anim.flip_h = velocity.x < 0
		return

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		anim.play(run_name)
		anim.flip_h = direction < 0
	else:
		anim.play(idle_name)

func _check_sword_hits() -> void:
	for area in sword_hitbox.get_overlapping_areas():
		if area.is_in_group("Enemy"):
			area.call_deferred("queue_free")

func equip_sword() -> void:
	if has_sword:
		return
	has_sword = true
	mensaje.text = "Obtuviste la espada"

func is_immune_to_enemy() -> bool:
	return has_sword


func kill_player() -> void:
	if is_dead:
		return

	is_dead = true
	is_attacking = false
	on_ladder = false
	velocity = Vector2.ZERO
	sword_hitbox.set_deferred("monitoring", false)
	mensaje.text = "Has muerto"
	anim.play("DeadHit")

	await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()

func _on_cadena_aerea_body_entered(body: Node2D) -> void:
	if body == self and not is_dead:
		on_ladder = true
		velocity = Vector2.ZERO

func _on_cadena_aerea_body_exited(body: Node2D) -> void:
	if body == self and not is_dead:
		on_ladder = false

func _on_trampolin_area_body_entered(body: Node2D) -> void:
	if body == self and not is_dead and velocity.y > 0.0:
		on_ladder = false
		velocity.y = TRAMPOLINE_BOOST

func _on_agua_body_entered(body: Node2D) -> void:
	if body == self:
		kill_player()

func _on_llave_body_entered(body: Node2D) -> void:
	if body == self and not is_dead:
		has_key = true
		get_parent().get_node("Llave").queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self and not is_dead:
		var tesoro = get_parent().get_node("Tesoro")
		if has_key:
			mensaje.text = "Encontraste el tesoro"
			tesoro.reproducir_animacion()

			if not sword_spawned and sword_scene != null:
				var sword := sword_scene.instantiate()
				sword.global_position = tesoro.global_position + Vector2(0, -32)
				get_tree().current_scene.call_deferred("add_child", sword)
				sword_spawned = true
		else:
			mensaje.text = "Te falta la llave"

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "Attack":
		is_attacking = false
