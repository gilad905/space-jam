extends Node2D


@export_category("Planet Scenes")
@export var planet_scenes: Array[PackedScene] = []


@export_category("Map")
@export var map_top_left := Vector2.ZERO
@export var map_size := Vector2(3000.0, 2000.0)


@export_category("Spawning")
@export_range(1, 100, 1)
var planet_count: int = 10

@export var minimum_gap: float = 100.0

@export_range(1, 1000, 1)
var max_attempts_per_planet: int = 100

# Layer 2 has the integer value 2.
@export var planet_surface_mask: int = 2


@onready var planets_container: Node2D = $Planets

var random := RandomNumberGenerator.new()


func _ready() -> void:
	random.randomize()

	# Wait until the physics world is available.
	await get_tree().physics_frame

	await spawn_planets()


func spawn_planets() -> void:
	if planet_scenes.is_empty():
		push_error("No planet scenes selected.")
		return

	for planet_number in range(planet_count):
		var selected_scene := get_random_planet_scene()
		var planet := selected_scene.instantiate() as Node2D

		if planet == null:
			push_error("Planet scene root must be a Node2D.")
			continue

		var planet_radius := get_planet_radius(planet)

		if planet_radius <= 0.0:
			planet.queue_free()
			continue

		var spawn_position := find_free_position(planet_radius)

		if spawn_position == Vector2.INF:
			push_warning(
				"No free position found for planet %d."
				% (planet_number + 1)
			)

			planet.queue_free()
			continue

		planets_container.add_child(planet)
		planet.global_position = spawn_position

		# Make this new planet visible to the physics world
		# before checking the position of the next planet.
		await get_tree().physics_frame


func get_random_planet_scene() -> PackedScene:
	var random_index := random.randi_range(
		0,
		planet_scenes.size() - 1
	)

	return planet_scenes[random_index]


func get_planet_radius(planet: Node2D) -> float:
	var collision := planet.get_node_or_null(
		"Surface/SurfaceCollision"
	) as CollisionShape2D

	if collision == null:
		push_error(
			"%s has no Surface/SurfaceCollision node."
			% planet.name
		)
		return 0.0

	var circle := collision.shape as CircleShape2D

	if circle == null:
		push_error(
			"%s must use a CircleShape2D."
			% planet.name
		)
		return 0.0

	return circle.radius


func find_free_position(planet_radius: float) -> Vector2:
	for attempt in range(max_attempts_per_planet):
		var candidate := create_random_position(planet_radius)

		if is_position_free(candidate, planet_radius):
			return candidate

	return Vector2.INF


func create_random_position(planet_radius: float) -> Vector2:
	var minimum_x := map_top_left.x + planet_radius
	var maximum_x := (
		map_top_left.x
		+ map_size.x
		- planet_radius
	)

	var minimum_y := map_top_left.y + planet_radius
	var maximum_y := (
		map_top_left.y
		+ map_size.y
		- planet_radius
	)

	return Vector2(
		random.randf_range(minimum_x, maximum_x),
		random.randf_range(minimum_y, maximum_y)
	)


func is_position_free(
	candidate: Vector2,
	planet_radius: float
) -> bool:
	var test_circle := CircleShape2D.new()

	# The extra gap is included in the test circle.
	test_circle.radius = planet_radius + minimum_gap

	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = test_circle
	query.transform = Transform2D(0.0, candidate)

	# Only test against planet surfaces.
	query.collision_mask = planet_surface_mask
	query.collide_with_bodies = true
	query.collide_with_areas = false

	var physics_space := get_world_2d().direct_space_state
	var collisions := physics_space.intersect_shape(query, 1)

	return collisions.is_empty()


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
