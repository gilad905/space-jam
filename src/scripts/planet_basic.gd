class_name Planet
extends StaticBody2D

@export_category("Planet")
@export var planet_radius: float = 200.0
@export var gravity_radius: float = 600.0
@export var gravity_strength: float = 900.0

@onready var surface_collision: CollisionShape2D = $SurfaceCollision
@onready var gravity_area: Area2D = $GravityArea
@onready var gravity_collision: CollisionShape2D = $GravityArea/GravityCollision


func _ready() -> void:
	_update_collision_radii()

	gravity_area.body_entered.connect(_on_gravity_body_entered)
	gravity_area.body_exited.connect(_on_gravity_body_exited)


func _update_collision_radii() -> void:
	# Create the solid planet collision circle.
	var surface_shape := CircleShape2D.new()
	surface_shape.radius = planet_radius
	surface_collision.shape = surface_shape

	# Create the larger invisible gravity circle.
	var gravity_shape := CircleShape2D.new()
	gravity_shape.radius = max(gravity_radius, planet_radius)
	gravity_collision.shape = gravity_shape


func _on_gravity_body_entered(body: Node2D) -> void:
	if body.has_method("enter_planet_gravity"):
		body.enter_planet_gravity(self)


func _on_gravity_body_exited(body: Node2D) -> void:
	if body.has_method("exit_planet_gravity"):
		body.exit_planet_gravity(self)
