class_name Player
extends CharacterBody2D

@export var move_speed: float = 200.0

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var last_direction: String = "down"

func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity = input_vector * move_speed
		
		if input_vector.x != 0:
			last_direction = "side"
			sprite.flip_h = input_vector.x < 0
			anim.play("walk_side")
		elif input_vector.y < 0:
			last_direction = "up"
			anim.play("walk_up")
		else:
			last_direction = "down"
			anim.play("walk_down")
	else:
		velocity = Vector2.ZERO
		# Play idle animation based on last direction faced
		print(last_direction)
		match last_direction:
			"side":
				anim.play("idle_side")
			"up":
				anim.play("idle_up")
			"down":
				anim.play("idle_down")

	move_and_slide()
