extends Area2D

@export var launch_force: float = -1000.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	anim.play("Idle")

func _on_Canon_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player := body as CharacterBody2D
		if player:
			player.velocity.y = launch_force
		anim.play("Fire")

func _on_AnimatedSprite2D_animation_finished() -> void:
	if anim.animation == "Fire":
		anim.play("Idle")
