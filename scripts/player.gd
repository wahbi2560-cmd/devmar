extends CharacterBody3D

# Vitesse
const SPEED = 7.0
const ACCELERATION = 0.1
const FRICTION = 0.2
const JUMP_VELOCITY = 4.5
const SPRINT_SPEED = 12.0

# Caméra et souris
@onready var camera = $Camera3D
var mouse_sensitivity = 0.005
var camera_x_rotation = 0.0

# Gravité
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Inventaire et armes
var inventory = {"pistol": true}
var has_pistol = true
var current_weapon = "pistol"

# HUD
var hud_label: Label

func _ready():
	# Configuration caméra
	camera.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Créer HUD
	setup_hud()

func _physics_process(delta):
	# Appliquer la gravité
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Sauter
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Mouvement
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Sprint
	var current_speed = SPRINT_SPEED if Input.is_action_pressed("ui_shift") else SPEED
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * current_speed, ACCELERATION)
		velocity.z = lerp(velocity.z, direction.z * current_speed, ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0.0, FRICTION)
		velocity.z = lerp(velocity.z, 0.0, FRICTION)
	
	move_and_slide()

func _input(event):
	# Rotation caméra avec souris
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var rot = event.relative
		
		# Rotation horizontale (Yaw)
		rotate_y(-rot.x * mouse_sensitivity)
		
		# Rotation verticale (Pitch)
		camera_x_rotation -= rot.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation, -PI/2, PI/2)
		camera.rotation.x = camera_x_rotation
	
	# Tir
	if event.is_action_pressed("shoot") and has_pistol:
		shoot()
	
	# Retirer/ajouter arme
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_1:
				current_weapon = "pistol" if has_pistol else None
				update_hud()
			elif event.keycode == KEY_0:
				current_weapon = None
				update_hud()

func shoot():
	if current_weapon != "pistol":
		return
	
	# Raycast depuis la caméra
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		camera.global_position,
		camera.global_position + camera.global_transform.basis.z * -1000
	)
	
	var result = space_state.intersect_ray(query)
	
	if result:
		var collider = result.collider
		
		# Dégâts aux NPCs
		if collider.has_method("take_damage"):
			collider.take_damage(25)
			print("Touched: ", collider.name)
		
		# Créer un effet visuel de balle
		create_bullet_impact(result.position)

func create_bullet_impact(pos: Vector3):
	# Particule/effet visuel simple
	var sphere = MeshInstance3D.new()
	sphere.mesh = SphereMesh.new()
	sphere.mesh.radius = 0.1
	sphere.mesh.height = 0.2
	sphere.global_position = pos
	get_parent().add_child(sphere)
	
	# Disparaître après 2 secondes
	await get_tree().create_timer(2.0).timeout
	sphere.queue_free()

func setup_hud():
	hud_label = Label.new()
	hud_label.anchors_left = 0
	hud_label.anchors_top = 0
	hud_label.size = Vector2(300, 100)
	add_child(hud_label)
	update_hud()

func update_hud():
	var text = "[E] Inventaire: "
	if has_pistol:
		text += "Pistolet (%s) " % ("ACTIF" if current_weapon == "pistol" else "INACTIF")
	text += "\n[1] Pistolet | [0] Désarmer"
	text += "\n[SOURIS] Regarder | [CLIC] Tirer | [F] Tirer"
	text += "\n[ESPACE] Sauter | [MAJ] Sprint"
	hud_label.text = text
