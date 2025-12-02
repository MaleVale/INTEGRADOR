extends CharacterBody2D

@export var speed: float = 60.0
@export var start_direction: int = 1  # 1 = derecha, -1 = izquierda

@onready var punto_izquierda: Marker2D = $PuntoIzquierda
@onready var punto_derecha: Marker2D = $PuntoDerecha

var direction: int
var left_limit_x: float
var right_limit_x: float

func _ready() -> void:
	direction = start_direction

	left_limit_x = punto_izquierda.global_position.x
	right_limit_x = punto_derecha.global_position.x
	
	if left_limit_x > right_limit_x:
		var tmp = left_limit_x
		left_limit_x = right_limit_x
		right_limit_x = tmp

func _physics_process(delta: float) -> void:
	velocity.x = direction * speed
	velocity.y = 0
	move_and_slide()

	if direction == 1 and global_position.x >= right_limit_x:
		global_position.x = right_limit_x
		direction = -1
	elif direction == -1 and global_position.x <= left_limit_x:
		global_position.x = left_limit_x
		direction = 1
