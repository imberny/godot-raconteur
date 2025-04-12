class_name RaconteurInstructionAliased extends Resource

@export var name: StringName
@export var args: Array

func _init(name_: StringName, args_: Array) -> void:
    name = name_
    args = args_