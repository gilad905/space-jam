extends RigidBody2D

@export var forward_force: float = 300.0
@export var turn_torque: float = 1200.0
@export var min_speed: float = 100.0
@export var max_speed: float = 400.0

func _physics_process(_delta: float) -> void:
	# 1. Constant forward thrust along local UP
	var forward_dir := Vector2.UP.rotated(rotation)
	apply_central_force(forward_dir * forward_force)
	
	# 2. Rotational torque based on side inputs (A/D or Left/Right)
	var turn_input := Input.get_axis("left", "right") # -1.0 (left), 1.0 (right)
	if turn_input != 0.0:
		apply_torque(turn_input * turn_torque)

	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
	if linear_velocity.length() < min_speed:
		linear_velocity = linear_velocity.normalized() * min_speed

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("walls"):
		$"..".call_deferred("crash")

func _freeze() -> void:
	freeze = true
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
