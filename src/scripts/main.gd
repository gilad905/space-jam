extends Node2D


func _on_goal_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$winning.visible = true
