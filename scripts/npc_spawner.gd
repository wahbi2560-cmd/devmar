extends Node3D

@export var num_civils = 10
@export var num_police = 3

var npc_scene: PackedScene

func _ready():
	# Créer scene NPC
	create_npc_scene()

func create_npc_scene():
	# NPC basique avec collision
	var npc = CharacterBody3D.new()
	npc.script = load("res://scripts/npc.gd")
	
	# Mesh corps
	var body = MeshInstance3D.new()
	body.mesh = BoxMesh.new()
	npc.add_child(body)
	
	# Collision
	var collision = CollisionShape3D.new()
	collision.shape = BoxShape3D.new()
	npc.add_child(collision)
	
	# Sauvegarder la scène
	npc_scene = npc

func spawn_npcs():
	# Spawner civils
	for i in range(num_civils):
		spawn_npc(NPC.NPCType.CIVIL)
	
	# Spawner police
	for i in range(num_police):
		spawn_npc(NPC.NPCType.POLICE)

func spawn_npc(npc_type):
	var npc = CharacterBody3D.new()
	var script = load("res://scripts/npc.gd")
	npc.set_script(script)
	npc.npc_type = npc_type
	
	# Mesh
	var mesh_instance = MeshInstance3D.new()
	var mesh = CapsuleMesh.new()
	mesh_instance.mesh = mesh
	
	# Couleur
	if npc_type == 0:  # CIVIL
		mesh_instance.get_active_material(0).albedo_color = Color.GRAY
	else:  # POLICE
		mesh_instance.get_active_material(0).albedo_color = Color.BLUE
	
	npc.add_child(mesh_instance)
	
	# Collision
	var collision = CollisionShape3D.new()
	collision.shape = CapsuleShape3D.new()
	npc.add_child(collision)
	
	# Position aléatoire
	npc.global_position = Vector3(
		randf_range(-100, 100),
		1,
		randf_range(-100, 100)
	)
	
	npc.name = "NPC_" + str(npc_type) + "_" + str(randi())
	add_child(npc)
