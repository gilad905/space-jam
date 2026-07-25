extends Node2D


func _on_goal_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$hud/winning.visible = true
		$Sounds/AudWin.play()


func _on_boundaries_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$hud/losing.visible = true
		$Sounds/AudImpact.play()
		$Sounds/AudExplosion.play()
		$Sounds/AudThrusterFire.stop()
		$Sounds/AudSpaceEngine.stop()
		
