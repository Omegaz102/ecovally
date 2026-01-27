extends CharacterBody3D

var sens = 0.3	#mouse sensitivity
const maxSpeed = 30
const maxRunSpeed = 50
const walkAcceleration = 20
const runAcceleration = 25
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
	if Input.is_action_just_pressed("run") and stamina > 0:
		running = 1
	print(running)
	
	if running:
		stamina -= 10 * delta
	else:
		stamina += 2 * delta

	stamina = clamp(stamina, 0, 100)

	%StaminaMeater.frame = remap(stamina, 100, 0, 0, 60)
	

	stamina += (1 - running) * 2 * delta 
	
	if running: #make adams code more comprehensible
		acceleration = float(inputVector2D.length()) * runAcceleration
	else:
		acceleration = float(inputVector2D.length()) * walkAcceleration
	
	if velocity.length() > inputVector2D.length() * (maxSpeed + running * maxRunSpeed): # nice lerp velovity thing
		velocity = velocity.lerp(Vector3.ZERO, deceleration * delta)
	
	velocity += inputVector3D * acceleration * delta
	
	move_and_slide()
