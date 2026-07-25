extends Camera2D

func _process(delta):
	# Update the camera's position to follow the player
	var player = get_node("/root/Main/Player")  # Adjust the path to your player node
	if player:
		global_position.x = player.global_position.x
