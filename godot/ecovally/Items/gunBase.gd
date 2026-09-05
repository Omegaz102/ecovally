extends "res://Interactable.gd"

var equipped: bool = false
var reloading: bool = false

@export var magSize: int = 5
@export var bloom: float = 0.05 #spread
@export var reloadSpeed: float = 1.0
@export var ShotsPerSecond: float = 60.0

@onready var mag: int = magSize
var shotCooldown: float = 0.0


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


func shoot() -> void:
	# Stops shooting if reload or no bullets
	if mag <= 0 or reloading:
		return

	mag -= 1

	$RayCast3D.position = Vector3.ZERO
	$RayCast3D.rotation = Vector3.ZERO

	$RayCast3D.rotate_x(randf_range(-bloom, bloom))
	$RayCast3D.rotate_y(randf_range(-bloom, bloom))

	$RayCast3D.force_raycast_update()

	shotCooldown += 1.0 / ShotsPerSecond

	if $RayCast3D.is_colliding():
		var bulletHole = preload("res://Assets/Props/BulletHole/bullet_hole.tscn").instantiate()
		get_tree().root.add_child(bulletHole)

		bulletHole.global_position = $RayCast3D.get_collision_point()
		bulletHole.global_transform.basis = Basis.looking_at(
			$RayCast3D.get_collision_normal(),
			Vector3.UP
		)


func reload() -> void:
	# Don't reload if already reloading or the magazine is full
	if reloading or mag >= magSize:
		return

	reloading = true

	await get_tree().create_timer(reloadSpeed).timeout

	if is_inside_tree():
		mag = magSize
		reloading = false


func _process(_delta: float) -> void:
	if shotCooldown > 0:
		shotCooldown -= _delta

	$SubViewportContainer/SubViewport/GunCam.global_transform = Global.camera.global_transform

	if equipped:
		$MeshInstance3D.layers = 2

		# Reload
		if Input.is_action_just_pressed("reload"):
			reload()

		# Shooting
		while Input.is_action_pressed("shoot") and mag > 0 and shotCooldown <= 0 and not reloading:
			shoot()
	else:
		$MeshInstance3D.layers = 1
