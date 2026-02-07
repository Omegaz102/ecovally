extends CharacterBody3D
var sens: float = 0.3
var maxSpeed: float = 10
var speed: float = 40
var friction = 0.4
@export var movementCurve: Curve 

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:	#mouse input
		rotation_degrees.y -= event.relative.x * sens
		%Camera3D.rotation_degrees.x -= event.relative.y * sens
		%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, -80, 80)

func _physics_process(delta: float) -> void:
	var planarVelocity = Vector2(velocity.x, velocity.z)
	var inputVector2D = Input.get_vector("left", "right", "forward", "backward")
	inputVector2D = inputVector2D.normalized()
	var inputVector3D = Vector3(
		inputVector2D.x, 0, inputVector2D.y
	)
	inputVector3D = transform.basis * inputVector3D
	var planarInput = Vector2(inputVector3D.x, inputVector3D.z)
	
	planarVelocity = planarVelocity.normalized() * planarVelocity.length() * (planarVelocity.dot(planarInput)) 
	
	move_and_slide()
