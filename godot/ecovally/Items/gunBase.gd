extends "res://Interactable.gd"

var equipped: bool

@export var magSize: int = 0
@export var bloom: float = 0.05
@export var reloadSpeed: float = 1.0
@export var ShotsPerSecond: float = 60

@onready var mag = magSize
var shotCooldown: float

func _on_interacted() -> void:
	Global.hotBar.addItem(self)
	position = Vector3.ZERO
	rotation = Vector3.ZERO
	scale = Vector3(1, 1, 1)
	if get_parent():
		get_parent().remove_child(self)

func _on_tree_entered() -> void:
	if get_parent() == Global.hotBar:
		equipped = true
		$CollisionShape3D.disabled = true
	else:
		$CollisionShape3D.disabled = false

func _on_tree_exited() -> void:
	equipped = false

func shoot():
	mag -= 1 
	
	$RayCast3D.position = Vector3.ZERO
	$RayCast3D.rotation = Vector3.ZERO
	$RayCast3D.rotate_x(randf_range(-bloom, bloom))
	$RayCast3D.rotate_y(randf_range(-bloom, bloom))
	
	$RayCast3D.force_raycast_update()
	shotCooldown += 1 / ShotsPerSecond
	
	if $RayCast3D.is_colliding():
		var bulletHole = preload("res://Assets/Props/BulletHole/bullet_hole.tscn").instantiate()
		get_tree().root.add_child(bulletHole)

		bulletHole.global_position = $RayCast3D.get_collision_point()
		bulletHole.global_transform.basis = Basis.looking_at($RayCast3D.get_collision_normal(), Vector3.UP)
func _process(_delta: float) -> void:
	if shotCooldown > 0:
		shotCooldown -= _delta
	$SubViewportContainer/SubViewport/GunCam.global_transform = Global.camera.global_transform
	if equipped:
		$MeshInstance3D.layers = 2
		while Input.is_action_pressed("shoot") and mag > 0 and shotCooldown <= 0:
			shoot()
	else:
		$MeshInstance3D.layers = 1
