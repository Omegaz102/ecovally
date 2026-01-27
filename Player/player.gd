extends CharacterBody3D

var sens = 0.3	#mouse sensitivity
const maxSpeed = 15
const maxRunSpeed = 10
const walkAcceleration = 50
const runAcceleration = 15
const deceleration = 7	#velocity is divided by 1 + deceleration when decelerating
var deltaDeceleeration = 0	#Deceleeration acounting for dt
var acceleration = 0 	#how much to accelerate
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
		running = 1
	if Input.is_action_just_released("run") or stamina <= 0:
		running = 0 
	print(running)
	stamina -= running * delta
	%StaminaMeater.frame = remap(stamina, 100, 0, 0, 60)
	stamina -= running * 10 * delta
	stamina += (1 - running) * 2 * delta 
	acceleration = float(inputVector2D.length()) * walkAcceleration + runAcceleration * running * float(inputVector2D.length())
	
	if velocity.length() > inputVector2D.length() * (maxSpeed + running * maxRunSpeed):	#deccelerates when velocity length > target speed
		deltaDeceleeration = deceleration * delta
		deltaDeceleeration = deltaDeceleeration + 1
		velocity = velocity.length() * deltaDeceleeration * velocity.normalized()
		if velocity.length() < inputVector2D.length() * (maxSpeed + running * maxRunSpeed):
			velocity = acceleration * velocity.normalized()
	
	velocity += inputVector3D * acceleration * delta
	
	move_and_slide()
