extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var player: CharacterBody3D = Global.player

const SPEED = 3.0
const STOP_DISTANCE = 1.67

func _ready():
	randomize()

func _physics_process(delta: float) -> void:
	
	if player:
		navigation_agent_3d.set_target_position(player.global_position)

	if navigation_agent_3d.is_navigation_finished():
		velocity = Vector3.ZERO
		return

	var next_position = navigation_agent_3d.get_next_path_position()
	var direction = (next_position - global_position).normalized()

	# Stops close to player
	if player and global_position.distance_to(player.global_position) < STOP_DISTANCE:
		velocity = Vector3.ZERO
	else:
		velocity = direction * SPEED

	move_and_slide()
