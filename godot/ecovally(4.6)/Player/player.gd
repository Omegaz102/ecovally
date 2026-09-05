extends CharacterBody3D

var sens = 0.3	#mouse sensitivity

# MOVEMENT
var running = false 
var groundLarp = 30 # Speed of lerping between velocity while on ground
var airLarp = 2 # air resistance (basically ^ but on ground)
var maxSpeed = 3.5 #67 (3.5 feels more weighty -ET)
var maxRunSpeed = 2 #41
var crouchSpeed = 1.75 # the speed of which you crouch

# VAULTING
var disableMovment = false
var vaulting = false
var vaultTarget = Vector3()
var vaultStartingPos = Vector3()

# STAMINA
var staminaRegen = 15
var stamina = 100 #I don't think this needs explaination
var canRun = true
var staminaDrain = -10

#I LOVE GOONING SO MUCH IT IS SO SIGOY
# CROUCHING
var crouching = false
var target_scale_y = 1.0  # Target scale when not crouching
var lerp_speed = 5.0  # Controls how fast the lerp happens

# ROTATION
var disablePlatformInherit = false # Self explanatory, if true, you will not rotate with the object below you, if false you will.
var lastFloorTransform: Transform3D
var lastFloor: Node3D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.player = self
	Global.camera = %Camera3D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:	#mouse input
		rotation_degrees.y -= event.relative.x * sens
		%Camera3D.rotation_degrees.x -= event.relative.y * sens
		%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, -80, 80)

func _physics_process(delta: float) -> void:
	%FPSDisplay.text = str(floor(1/delta)) #converts wasd input into vectors
	var inputVector2D = Input.get_vector("left", "right", "forward", "backward")
	inputVector2D = inputVector2D.normalized()
	var is_moving = inputVector2D.length() > 0 # self explanatory
	var inputVector3D = Vector3(
		inputVector2D.x, 0, inputVector2D.y
	)
	inputVector3D = transform.basis * inputVector3D
	
	if not is_on_floor() and Input.is_action_just_pressed("jump"):
		if not $MantleRayCasters/Alpha.is_colliding() and $MantleRayCasters/Beta.is_colliding() and $MantleRayCasters/Gamma.is_colliding() and not vaulting:
			$MantleRayCasters/Timer.start()
			disableMovment = true
			vaulting = true
			vaultTarget = $MantleRayCasters/Beta.get_collision_point()
			vaultStartingPos = position
			$CollisionShape3D.disabled = true
	
	if vaulting:
		position = lerp(vaultTarget, vaultStartingPos, $MantleRayCasters/Timer.time_left / $MantleRayCasters/Timer.wait_time)
	if $MantleRayCasters/Timer.time_left == 0 and vaulting:
		disableMovment = false
		vaulting = false
		$CollisionShape3D.disabled = false
	
#	velocity.y += int(is_on_floor()) * int(Input.is_action_just_pressed("jump")) * 6.7 # adds jumping n' shit
#	velocity.vel += int(is_on_floor()) * int(Input.is_action_just_pressed("jump"))
	
	if Input.is_action_pressed("run") and !crouching and canRun and is_moving: #Check if running
		running = true
	else:
		running = false
		
	if canRun: #check for no stamina left
		if stamina <= 0 and canRun:
			canRun = false
	else:
		if stamina >= 100 and !canRun:
			canRun = true
	
	if Input.is_action_just_pressed("crouch"):
		crouching = true
		$CollisionShape3D.scale.y = 0.5  

	if Input.is_action_just_released("crouch"):
		crouching = false
	if not crouching:
		$CollisionShape3D.scale.y = lerp($CollisionShape3D.scale.y, target_scale_y, lerp_speed * delta)
	
	var draining: int = (running and is_moving)
	
	stamina += delta * (staminaDrain * draining + staminaRegen * (1 - draining))

	stamina = clamp(stamina, 0, 100)
	%StaminaMeater.frame = remap(stamina, 100, 0, 0, 60)
	 
	
	var planarVelocity = Vector2(velocity.x, velocity.z) #seperates planar movment so planar movment doesn't affect jumping/falling
	var targetVelocity = Vector2() #planar velocity sans lerp
	if inputVector2D.length() > 0: #new system for handling movement
		if crouching == false:
			targetVelocity = (maxSpeed + maxRunSpeed * int(running)) * Vector2(inputVector3D.x, inputVector3D.z)  # target speed get's what will be lerped to
		else:
			targetVelocity = crouchSpeed * Vector2(inputVector3D.x, inputVector3D.z)
	
	
	else:
		targetVelocity = Vector2()

	velocity.y -= 9.8 * delta * 2 #Gravity n' shit(regular gravity was too floaty)
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += 6.7
		planarVelocity = planarVelocity * 1.15

	var currentLarp = groundLarp if is_on_floor() else airLarp # air resistence logic
	planarVelocity = lerp(planarVelocity, targetVelocity, delta * currentLarp)
	
	if disableMovment:
		velocity = Vector3()
	else:
		velocity = Vector3(planarVelocity.x, velocity.y, planarVelocity.y)
		
	move_and_slide()

	if is_on_floor():
		var floorCollision: KinematicCollision3D = get_last_slide_collision()
		if floorCollision and !disablePlatformInherit:
			var floorNode = floorCollision.get_collider()
			
			
			if floorNode is Node3D:
				if floorNode != lastFloor:
					lastFloor = floorNode
					lastFloorTransform = floorNode.global_transform
				else:
					var prevBasis = lastFloorTransform.basis
					var currTransform = floorNode.global_transform
					var deltaBasis = currTransform.basis * prevBasis.inverse()

					global_transform.basis = deltaBasis * global_transform.basis

					var pivot = currTransform.origin
					global_position = pivot + deltaBasis * (global_position - pivot)

					lastFloorTransform = currTransform
	else:
		lastFloor = null
