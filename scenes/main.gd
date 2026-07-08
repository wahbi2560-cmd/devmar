extends Node3D

@onready var player = $Player
@onready var npc_spawner = $NPCSpawner

func _ready():
	# Initialiser les NPCs
	npc_spawner.spawn_npcs()
	
	# Configuration caméra
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	pass

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
