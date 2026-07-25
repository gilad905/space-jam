extends Camera2D

func _process(_delta):
	# Update the camera's position to follow the player
	var player = get_node("/root/Main/Player")  # Adjust the path to your player node
	if player:
		global_position = player.global_position
