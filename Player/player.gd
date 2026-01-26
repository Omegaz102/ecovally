extends CharacterBody3D

var sens = 0.5	#mouse sensitivity
const maxSpeed = 10	#max speed when walking
const maxRunSpeed = 50	#max speed when running
const walkAcceleration = 20
const runAcceleration = 40
var acceleration = 20	#adds acceleration * dt when accelerating
const deceleration = 3	#velocity is divided by 1 + deceleration when decelerating
var deltaDeceleeration = 0	#Deceleeration acounting for dt
var targetSpeed = 0 	#Target length of velocity

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:	#mouse input
		rotation_degrees.y -= event.relative.x * sens
		%Camera3D.rotation_degrees.x -= event.relative.y * sens
		%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, -80, 80)

func _physics_process(delta: float) -> void:
	var inputVector2D = Input.get_vector("left", "right", "forward", "backward")
	inputVector2D = inputVector2D.normalized()
	var inputVector3D = Vector3(
		inputVector2D.x, 0, inputVector2D.y
	)
	inputVector3D = transform.basis * inputVector3D	#converts global vector to local for movement
	if inputVector2D == Vector2(0,0):	#sets target speed
		targetSpeed = 0
	elif  Input.is_action_pressed("run"):
		targetSpeed = maxRunSpeed
		acceleration = runAcceleration
	else:
		targetSpeed = maxSpeed
		acceleration = walkAcceleration
	
	velocity += inputVector3D * acceleration * delta
	
	if velocity.length() > targetSpeed:	#deccelerates when velocity length > target speed
		deltaDeceleeration = deceleration * delta
		deltaDeceleeration = deltaDeceleeration + 1
		velocity = velocity.length() / deltaDeceleeration * velocity.normalized()
		if velocity.length() < targetSpeed:
			velocity = targetSpeed * velocity.normalized()
	
	print(1 / delta)
	move_and_slide()
