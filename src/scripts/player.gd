extends RigidBody2D

@export var strafe_force: float = 200.0
@export var turn_speed: float = 4.0

func _ready() -> void:
	pass

func _physics_process(_delta) -> void:
	#var turn_direction := Input.get_axis("ui_left", "ui_right")
	#rotation += turn_direction * turn_speed * delta
	#var forward_vector := Vector2.UP.rotated(rotation)
	#apply_central_force(forward_vector * forward_thrust)

	var side_input := Input.get_axis("ui_left", "ui_right") # returns -1.0, 0.0, or 1.0
	if side_input != 0.0:
		var right_dir := Vector2.RIGHT.rotated(rotation)
		apply_central_force(right_dir * side_input * strafe_force)
