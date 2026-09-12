extends CharacterBody3D

const STOP_DISTANCE = 10
const FOLLOWDISTANCE = 20
const SPEED = 10

var health := 20

var isWalking: bool

@onready var nav:NavigationAgent3D = $NavigationAgent3D
@onready var player:CharacterBody3D = Global.player

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	
	if position.distance_to(player.position) >= FOLLOWDISTANCE:
		isWalking = true
	
	if isWalking:
		nav.set_target_position(player.position)
		

	var next_position = nav.get_next_path_position()
	var direction = (next_position - global_position).normalized()

	# Stops close to player
	if player and global_position.distance_to(player.global_position) < STOP_DISTANCE:
		velocity = Vector3.ZERO
		isWalking = false
	
	if isWalking:
		velocity = direction * SPEED

	move_and_slide()

func die() -> void:
	print("Enemy died")
	queue_free()

func damage(amount: float) -> void:
	health -= amount
	print("Enemy took damage: ", amount, " | Health left: ", health)
	
	if health <= 0:
		die()
