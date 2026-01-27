extends CharacterBody3D

var sens = 0.3	#mouse sensitivity
const minSpeed = 3 #minimum speed while walking/running
const maxSpeed = 6.7 #67
const maxRunSpeed = 4.1 #41
const walkAcceleration = 2
const runAcceleration = 25
const deceleration = 30	#velocity is divided by 1 + deceleration when decelerating
var acceleration = 30 	#how much to accelerate
var stamina = 100 #I don't think this needs explaination
var running = false # 1 or 0 for is running, not bool because I can avoid an if statement if by making it a number
const larp = 30 # Speed of lerping between velocity

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
	
	velocity.y -= 9.8 * delta * 2 #Gravity n' shit(regular gravity was too floaty)
	velocity.y += int(is_on_floor()) * int(Input.is_action_just_pressed("jump")) * 6.7 # adds jumping n' shit
	
	if Input.is_action_just_pressed("run") and stamina >= 0:
		running = true
	if Input.is_action_just_released("run") or stamina <= 0:
		running = false
	
	stamina -= 40 * delta * int(running)
	stamina += 40 * delta * (1 - int(running))
	
	stamina = clamp(stamina, 0, 100)

	%StaminaMeater.frame = remap(stamina, 100, 0, 0, 60)
	
	var planarVelocity = Vector2(velocity.x, velocity.z) #seperates planar movment so planar movment doesn't affect jumping/falling
	var targetVelocity = Vector2() #planar velocity sans lerp
	if inputVector2D.length() > 0: #new system for handling movement
		targetVelocity = (maxSpeed + maxRunSpeed * int(running)) * Vector2(inputVector3D.x, inputVector3D.z)  # target speed get's what will be lerped to
	
	else:
		targetVelocity = Vector2()
	
	planarVelocity = lerp(planarVelocity, targetVelocity, delta * larp)
	velocity = Vector3(planarVelocity.x, velocity.y, planarVelocity.y)
	
	move_and_slide()
