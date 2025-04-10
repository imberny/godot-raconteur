class_name RaconteurInstructionDefinition

var name: String
var args: Array
var callback: Callable


func _init(name_: String, args_: Array) -> void:
	name = name_
	args = args_


func is_eq(other: RaconteurInstructionDefinition) -> bool:
	return name == other.name and args == other.args and callback == other.callback
