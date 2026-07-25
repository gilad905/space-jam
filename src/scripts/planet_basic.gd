extends Node2D

@export_range(0.0, 5000.0, 10.0)
var gravity_strength: float = 150.0

@onready var gravity_area: Area2D = $GravityArea


func _ready() -> void:
	gravity_area.gravity = gravity_strength
