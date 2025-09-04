class_name LightSource
extends Node2D

@export var base_scale: float = 4.0
@export var target_scale: float = 3.0
@export var speed: float = 1.0
@export var energy: float = 1.0
@export var color: Color = Color("#7878ad")


@onready var light: PointLight2D = $PointLight2D

var time: float = 0.0

func _ready() -> void:
	if light:
		light.texture_scale = base_scale
		light.energy = energy
		light.color = color
	else:
		push_error("Light not found")


func _process(delta: float) -> void:
	time += speed * delta
	var t = (sin(time * PI * 2) + 1) / 2.0
	light.texture_scale = lerp(base_scale, target_scale, t)
