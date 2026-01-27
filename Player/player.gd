extends CharacterBody3D

var sens = 0.3	#mouse sensitivity
const minSpeed = 5 #minimum speed while walking/running
const maxSpeed = 30
const maxRunSpeed = 50
const walkAcceleration = 20
const runAcceleration = 25
const deceleration = 15	#velocity is divided by 1 + deceleration when decelerating
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
	%FPSDisplay.text = str(floor(1/delta))
	var inputVector2D = Input.get_vector("left", "right", "forward", "backward")
	inputVector2D = inputVector2D.normalized()
	var inputVector3D = Vector3(
		inputVector2D.x, 0, inputVector2D.y
	)
	inputVector3D = transform.basis * inputVector3D
	
	velocity.y -= 9.8 #Gravity n' shit
	
	
	if Input.is_action_just_pressed("run") and stamina >= 0:
		running = 1
	if Input.is_action_just_released("run") or stamina <= 0:
		running = 0 
	
	stamina -= 10 * delta * running
	stamina += 2 * delta * (1 - running)
	
	stamina = clamp(stamina, 0, 100)

	%StaminaMeater.frame = remap(stamina, 100, 0, 0, 60)
	
#	if running: #make adams code more comprehensible -- LEGACY CODE
#		acceleration = float(inputVector2D.length()) * runAcceleration
#	else:
#		acceleration = float(inputVector2D.length()) * walkAcceleration
#	
#	if velocity.length() > inputVector2D.length() * (maxSpeed + running * maxRunSpeed): # nice lerp velovity thing
#		velocity = velocity.lerp(Vector3.ZERO, deceleration * delta)
#	velocity += inputVector3D * acceleration * delta
	
	var planarVelocity = Vector2(velocity.x, velocity.z) #seperates planar movment so planar movment doesn't affect jumping/falling
	if inputVector2D.length() > 0: #new system for handling movement
		if planarVelocity.length() < minSpeed:
			planarVelocity = Vector2(inputVector3D.x, inputVector3D.z) * minSpeed
		else:
			pass
	else:
		planarVelocity = planarVelocity.normalized() * (planarVelocity.length() - deceleration * delta)
		
	
	velocity = Vector3(planarVelocity.x, velocity.y, planarVelocity.y)
	
	move_and_slide()
