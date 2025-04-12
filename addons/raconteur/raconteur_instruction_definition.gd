## An instance of this class defines a raconteur instruction.
## Think of instructions as your own domain specific language for your writers.
class_name RaconteurInstructionDefinition extends Resource

enum ArgType {
	ENTITY,
	ENUM,
	LINE,
}

@export var name: String
@export var args: Array[StringName]
@export var arg_types: Array[ArgType]

var callback: Callable


func _init(name_: String, args_: Array[StringName], arg_types_: Array[ArgType]) -> void:
	name = name_
	args = args_
	arg_types = arg_types_


func is_eq(other: RaconteurInstructionDefinition) -> bool:
	return name == other.name and args == other.args and callback == other.callback
