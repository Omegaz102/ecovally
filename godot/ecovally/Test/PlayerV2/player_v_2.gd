extends RigidBody3D
var sens: float = 0.3
var maxSpeed: float = 20
var speed: float = 20

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:	#mouse input
		$Node3D.rotation_degrees.y -= event.relative.x * sens
		%Camera3D.rotation_degrees.x -= event.relative.y * sens
		%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, -80, 80)

func _physics_process(delta: float) -> void:
	var inputVector2D = Input.get_vector("left", "right", "forward", "backward")
	inputVector2D = inputVector2D.normalized()
	var inputVector3D = Vector3(
		inputVector2D.x, 0, inputVector2D.y
	)
	inputVector3D = $Node3D.transform.basis * inputVector3D
	
	linear_velocity += inputVector3D * (maxSpeed - Vector2(axis_lock_linear_x,linear_velocity.z).length()) / maxSpeed * speed * delta
	
	if Input.is_action_just_pressed("jump") and $RayCast3D.is_colliding():
		linear_velocity.y += 5
		
