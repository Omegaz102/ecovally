extends "res://Interactable.gd"
var equiped: bool
@export var magSize: int = 0
@export var bloom: float = 0
@export var reloadSpeed: float = 0
@export var TimeBetweenShots: float = 0

@onready var mag = magSize

func _on_interacted() -> void:
	Global.hotBar.addItem(self)
	position = Vector3()
	rotation = Vector3()
	scale = Vector3(1, 1, 1)
	get_parent().remove_child(self)


func _on_tree_entered() -> void:
	if get_parent() == Global.hotBar:
		equiped = true
		$CollisionShape3D.disabled = true
	else:
		$CollisionShape3D.disabled = false

func _on_tree_exited() -> void:
	equiped = false

func shoot():
	$RayCast3D.posistion = Vector3()
	$RayCast3D.rotation = Vector3()
	$RayCast3D.rotate_x(randf_range(-bloom, bloom))
	$RayCast3D.rotate_y(randf_range(-bloom, bloom))
	var BulletHole: Node3D = preload("res://Assets/Props/BulletHole/bullet_hole.tscn").instantiate()
	get_tree().get_root().add_child(BulletHole)
	BulletHole.global_position = $RayCast3D.get_collision_point()
	
	print('shot')
#	BulletholeInstance.position = $RayCast3D.get_collision_point():
	

func  _process(delta: float) -> void:
	if equiped:
		if Input.is_action_pressed("shoot"):
			if mag > 0:
				shoot()
