extends Node2D


func _on_goal_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$hud/winning.visible = true
		$Sounds/AudWin.play()
		self.call_deferred("_restart")

func _on_boundaries_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$hud/losing.visible = true
		$Sounds/AudImpact.play()
		$Sounds/AudExplosion.play()
		$Sounds/AudThrusterFire.stop()
		$Sounds/AudSpaceEngine.stop()
		self.call_deferred("_restart")

func _restart() -> void:
	$Player._freeze()
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
