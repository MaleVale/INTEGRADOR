extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if anim:
		anim.play("default") 

func _on_Espada_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.has_method("equip_sword"):
		body.equip_sword()
		queue_free()
