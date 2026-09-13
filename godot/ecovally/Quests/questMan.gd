extends Node
class_name questMan

var activeQuests:Dictionary
var completedQuests:Array

func _ready() -> void:
	Global.questMan = self

# to start a quest run this command with the path to the quest
func startQuest(scriptPath:String):
	print("started:"+scriptPath)
	if not ResourceLoader.exists(scriptPath): # return false if wrong path
		return false
	if activeQuests.get(scriptPath.get_file()) != null: #return false if quest already active
		return false
	var script = load(scriptPath) # load script
	var newNode = Node.new() # create node
	newNode.set_script(script) # attach script
	newNode.name = scriptPath.get_file() # sets name to script name
	add_child(newNode) # adds the new node as a child
	return true
	# by adding the node as a child it can exist in the scene tree, independent of the quest manager

func _physics_process(delta: float) -> void:
	#print_tree_pretty()
	pass
