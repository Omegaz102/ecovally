extends CharacterBody3D

var sens = 0.3	#mouse sensitivity
const maxSpeed = 10	#max speed when walking
const maxRunSpeed = 20	#speed add when running
const walkAcceleration = 10
const runAcceleration = 5
var acceleration = 20	#adds acceleration * dt when accelerating
const deceleration = 5	#velocity is divided by 1 + deceleration when decelerating
var deltaDeceleeration = 0	#Deceleeration acounting for dt
var targetSpeed = 0 	#Target length of velocity
var stamina = 100 #I don't think this needs explaination
var running = 0 # 1 or 0 for is running, not bool because I can avoid an if statement if by making it a number

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
	inputVector3D = transform.basis * inputVector3D
	
	
	
	if Input.is_action_just_pressed("run"):
		running == 1
	if Input.is_action_just_released("run") or stamina:
		running == 0
	
	targetSpeed = float(inputVector2D.length()) * walkAcceleration + runAcceleration * running
	
	velocity += inputVector3D * acceleration * delta
	
	if velocity.length() > targetSpeed:	#deccelerates when velocity length > target speed
		deltaDeceleeration = deceleration * delta
		deltaDeceleeration = deltaDeceleeration + 1
		velocity = velocity.length() / deltaDeceleeration * velocity.normalized()
		if velocity.length() < targetSpeed:
			velocity = targetSpeed * velocity.normalized()
	
	print(1 / delta)
	move_and_slide()
