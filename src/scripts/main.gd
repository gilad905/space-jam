extends Node2D


func _on_goal_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$hud/winning.visible = true


func _on_boundaries_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$hud/losing.visible = true
		$Sounds/AudExplosion.play()
		$Sounds/AudThrusterFire.stop()
		
