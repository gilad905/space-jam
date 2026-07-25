extends RigidBody2D

@export var forward_force: float = 300.0
@export var turn_torque: float = 1200.0
var crashed: bool = false

func _physics_process(_delta: float) -> void:
	if crashed:
		return

	# 1. Constant forward thrust along local UP
	var forward_dir := Vector2.UP.rotated(rotation)
	apply_central_force(forward_dir * forward_force)
	
	# 2. Rotational torque based on side inputs (A/D or Left/Right)
	var turn_input := Input.get_axis("ui_left", "ui_right") # -1.0 (left), 1.0 (right)
	if turn_input != 0.0:
		apply_torque(turn_input * turn_torque)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("obstacle"):
		crashed = true
