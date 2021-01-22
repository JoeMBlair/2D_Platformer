extends CanvasLayer

var debug_info : Dictionary
onready var label = get_node("CanvasLayer/Label")

func _ready():
	pass
	label.text = "boop2"

func display_info(scene, debug_dict):
	label.text = "aclled"
	# Add debug dict to 
	if debug_info.has(scene):
		for varible in debug_dict:			
				debug_info[scene][varible] = debug_dict[varible]
	else:
		debug_info[scene] = debug_dict
		
	if debug_info.size() > 0:
		label.text = ""
		for i_key in debug_info:
			label.text += "- " + str(i_key) + " -\n"
			for i_name in debug_info[i_key]:
					label.text += str(i_name) + ": " + str(debug_info[i_key][i_name]) + "\n"

func _process(_delta):
	pass


func _on_Timer_timeout():
	pass

