extends CharacterBody3D

# Types NPC
enum NPCType { CIVIL, POLICE }

@export var npc_type: NPCType = NPCType.CIVIL
@export var speed = 3.0
@export var max_health = 100.0

var health: float
var is_dead = false
var current_target: Vector3
var target_reached = false
var waypoints: Array[Vector3] = []
var current_waypoint_index = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Pour les policiers
var alert_level = 0.0
var player_spotted = false
var pursuit_target: CharacterBody3D = null

# Animation
var animation_player: AnimationPlayer

func _ready():
	health = max_health
	animation_player = AnimationPlayer.new()
	
	# Générer waypoints aléatoires
	generate_waypoints()
	update_target()

func _physics_process(delta):
	if is_dead:
		return
	
	# Appliquer gravité
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Patrouille ou poursuite
	if npc_type == NPCType.POLICE and player_spotted:
		pursue_player()
	else:
		patrol()
	
	move_and_slide()

func patrol():
	# Se diriger vers waypoint
	if not target_reached:
		var direction = (current_target - global_position).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		if global_position.distance_to(current_target) < 2.0:
			target_reached = true
			await get_tree().create_timer(2.0).timeout
			next_waypoint()
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.1)
		velocity.z = lerp(velocity.z, 0.0, 0.1)

func pursue_player():
	if not pursuit_target:
		return
	
	var direction = (pursuit_target.global_position - global_position).normalized()
	velocity.x = direction.x * (speed * 1.5)
	velocity.z = direction.z * (speed * 1.5)

func generate_waypoints():
	# Points de patrouille aléatoires
	for i in range(5):
		var random_pos = Vector3(
			randf_range(-50, 50),
			0,
			randf_range(-50, 50)
		)
		waypoints.append(random_pos)

func update_target():
	if waypoints.size() > 0:
		current_target = waypoints[current_waypoint_index]
		target_reached = false

func next_waypoint():
	current_waypoint_index = (current_waypoint_index + 1) % waypoints.size()
	update_target()

func take_damage(amount: float):
	health -= amount
	
	# Réaction NPC
	if npc_type == NPCType.CIVIL:
		alert_level = 1.0
	elif npc_type == NPCType.POLICE:
		player_spotted = true
	
	if health <= 0:
		die()

func die():
	is_dead = true
	# Désactiver physique et afficher corps
	set_physics_process(false)
	# Texture rouge (mort)
	modulate = Color.RED
	await get_tree().create_timer(5.0).timeout
	queue_free()

func spot_player(player: CharacterBody3D):
	if npc_type == NPCType.POLICE:
		player_spotted = true
		pursuit_target = player
		print("Police spotted player!")

func lose_sight():
	if npc_type == NPCType.POLICE:
		player_spotted = false
		pursuit_target = null
		alert_level = max(0, alert_level - 0.1)
