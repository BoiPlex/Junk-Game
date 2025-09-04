class_name Player
extends CharacterBody2D

@export var move_speed: float = 100.0
@export var dark_mode: bool = true

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D

@onready var light_source: LightSource = $LightSource
@onready var dark_background: CanvasModulate = $CanvasModulate

var facing: Direction.Facing = Direction.Facing.DOWN
var is_idle: bool = true
var is_walking: bool = false


func _ready() -> void:
	anim_tree.active = true


func _process(_delta: float) -> void:
	_update_animation_tree()
	
	# Update dark mode lighting
	light_source.visible = dark_mode
	dark_background.visible = dark_mode


func _physics_process(delta: float) -> void:
	var input_vector := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))

	if input_vector != Vector2.ZERO:
		is_walking = true
		input_vector = input_vector.normalized()
		velocity = input_vector * move_speed
		
		if input_vector.x != 0:
			sprite.flip_h = input_vector.x < 0
	else:
		is_walking = false
		velocity = Vector2.ZERO
	
	is_idle = not is_walking
	_handle_facing()

	move_and_slide()


func _handle_facing() -> void:
	if velocity.x > 0:
		facing = Direction.Facing.RIGHT
	elif velocity.x < 0:
		facing = Direction.Facing.LEFT
	elif velocity.y < 0:
		facing = Direction.Facing.UP
	elif velocity.y > 0:
		facing = Direction.Facing.DOWN


func _update_animation_tree() -> void:
	anim_tree["parameters/conditions/is_idle"] = is_idle
	anim_tree["parameters/conditions/is_walking_down"] = is_walking and facing == Direction.Facing.DOWN
	anim_tree["parameters/conditions/is_walking_up"] = is_walking and facing == Direction.Facing.UP
	anim_tree["parameters/conditions/is_walking_side"] = is_walking and (facing == Direction.Facing.LEFT or facing == Direction.Facing.RIGHT)
