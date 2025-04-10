class_name RaconteurScenarioNode extends Resource


class AliasedInstruction:
    extends Resource

    var name: StringName
    var args: Array

    func _init(name_: StringName, args_: Array) -> void:
        name = name_
        args = args_


@export var id: int
@export var label: StringName
@export var lines: Array[RaconteurLine]
@export var constraints: Array[RaconteurConstraint]
@export var next: Array[RaconteurScenarioNode]
@export var instructions: Array[AliasedInstruction]


func _init(id_: int) -> void:
    id = id_


func line_add(new_line: RaconteurLine) -> void:
    lines.append(new_line)


func constraint_add(new_constraint: RaconteurConstraint) -> void:
    constraints.append(new_constraint)


func next_add(next_node: RaconteurScenarioNode) -> void:
    next.append(next_node)


func instruction_add(instruction_name: StringName, aliased_args: Array) -> void:
    instructions.append(AliasedInstruction.new(instruction_name, aliased_args))