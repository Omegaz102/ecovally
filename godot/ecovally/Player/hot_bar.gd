extends Node3D

var selected: int = 0
var hotBar: Array = []
var size = 3
@onready var itemIcon: TextureRect = %ItemIcon

func _ready() -> void:
	print(itemIcon)
	Global.hotBar = self
	hotBar.resize(size)
	updateHotbarDisplay()

func addItem(item: Node) -> void:
	var equipped := false

	for i in range(hotBar.size()):
		if hotBar[i] == null:
			equipped = true
			hotBar[i] = item
			print("Added item: peepeepoopoo", hotBar[i])
			break

	if not equipped:
		print("Hotbar is full")

	print(hotBar)

func changeItem(item: Node) -> void:
	# Remove currently equipped item
	if get_child_count() != 0:
		remove_child(get_child(0))

	# Add newly selected item
	add_child(item)

func updateHotbarDisplay() -> void:
	if hotBar[selected] != null:
		pass
		# Get the item's icon
#		itemIcon.texture = hotBar[selected].itemIcon
#		itemIcon.visible = true
	else:
		pass
		# No item in this slot
#		itemIcon.texture = null
#		itemIcon.visible = false

func selectNextItem() -> void:
	selected += 1

	if selected >= hotBar.size():
		selected = 0

	if hotBar[selected] != null:
		changeItem(hotBar[selected])
	elif get_child_count() > 0:
		remove_child(get_child(0))

	updateHotbarDisplay()

func selectPreviousItem() -> void:
	selected -= 1

	if selected < 0:
		selected = hotBar.size() - 1

	if hotBar[selected] != null:
		changeItem(hotBar[selected])
	elif get_child_count() > 0:
		remove_child(get_child(0))

	updateHotbarDisplay()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("NextItem"):
		selectNextItem()

	if Input.is_action_just_pressed("PreviousItem"):
		selectPreviousItem()
