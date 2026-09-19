extends "res://Interactable.gd"
class_name GunClass

# State
var equipped: bool = false
var reloading: bool = false

# Config
@export var magSize: int = 5              # Bullets held per chamber
@export var spread: float = 0.05
@export var BulletRPS: float = 2        # Bullets loaded per second while reloading
@export var ShotsPerSecond: float = 5
@export var damage: float = 10.0          # Damage is PER BULLET so shotguns should have low damage but high amount of bullets.

@export var chambers: int = 1            # Number of chambers. Total capacity = magSize * chambers. This is what you reload by so if you have 2 chambers each holding 5 bullets you can fire a total of 10 bullets but you have to reload twice. if you reload once you only shoot 5. Mostly used for shotguns.

# true  = one trigger pull fires a full chamers worth of bullets at once.
# false = one trigger pull fires a single bullet, like normal.
# basically "is this a shotgun" var
@export var magDump: bool = false

@export var itemIcon: CompressedTexture2D # Hotbar icon

# Ammo
@onready var totalCapacity: int = magSize * chambers
@onready var mag: int = totalCapacity

var shotCooldown: float = 0.0

@onready var _collisionShape: CollisionShape3D = $CollisionShape3D
@onready var _rayCast: RayCast3D = $RayCast3D
@onready var _meshInstance: MeshInstance3D = $MeshInstance3D
@onready var _gunCam: Camera3D = $SubViewportContainer/SubViewport/GunCam

const BULLET_HOLE_SCENE := preload("res://Assets/Props/BulletHole/bullet_hole.tscn")


func _ready() -> void:
	if not tree_entered.is_connected(_on_tree_entered):
		tree_entered.connect(_on_tree_entered)
	if not tree_exited.is_connected(_on_tree_exited):
		tree_exited.connect(_on_tree_exited)
	_on_tree_entered()


# hotbar
func _on_interacted() -> void:
	Global.hotBar.addItem(self)
	position = Vector3.ZERO
	rotation = Vector3.ZERO
	scale = Vector3(1, 1, 1)

	if get_parent():
		get_parent().remove_child(self)


func _on_tree_entered() -> void:
	if not is_node_ready():
		return

	equipped = get_parent() == Global.hotBar
	_collisionShape.disabled = equipped


func _on_tree_exited() -> void:
	equipped = false
	cancelReload()


func shoot() -> void:
	print(mag)
	if mag <= 0 or reloading:
		return

	shotCooldown += 1.0 / ShotsPerSecond

	if magDump:
		var bulletsToFire: int = min(magSize, mag)
		mag -= bulletsToFire
		for i in range(bulletsToFire):
			_fireOneRay()
	else:
		# Fire a single bullet
		mag -= 1
		_fireOneRay()


# the raycast thing all in one cool func
func _fireOneRay() -> void:
	_rayCast.position = Vector3.ZERO
	_rayCast.rotation = Vector3.ZERO
	_rayCast.rotate_x(randf_range(-spread, spread))
	_rayCast.rotate_y(randf_range(-spread, spread))
	_rayCast.force_raycast_update()

	if _rayCast.is_colliding(): # Enemies should have the method
		var collider = _rayCast.get_collider()
		if collider and collider.has_method("take_damage"):
			collider.take_damage(damage)

		var bulletHole := BULLET_HOLE_SCENE.instantiate()
		get_tree().root.add_child(bulletHole)

		bulletHole.global_position = _rayCast.get_collision_point()
		bulletHole.global_transform.basis = Basis.looking_at(
			_rayCast.get_collision_normal(),
			Vector3.UP
		)


func reload() -> void:
	if reloading or mag >= totalCapacity:
		return

	var loadAmount: int = min(magSize, totalCapacity - mag)

	if loadAmount <= 0:
		return

	reloading = true
	print("reloading")
	await get_tree().create_timer(loadAmount / BulletRPS).timeout
	print("done reloading")
	if not is_inside_tree():
		reloading = false
		return

	mag += loadAmount
	reloading = false


func cancelReload() -> void:
	reloading = false

func _process(delta: float) -> void:
	if shotCooldown > 0:
		# print(shotCooldown)
		shotCooldown -= delta

	_gunCam.global_transform = Global.camera.global_transform

	if equipped:
		_meshInstance.layers = 2

		if Input.is_action_just_pressed("reload"):
			reload()

		if Input.is_action_pressed("shoot") and mag > 0 and shotCooldown <= 0 and not reloading:
			shoot()
	else:
		_meshInstance.layers = 1
