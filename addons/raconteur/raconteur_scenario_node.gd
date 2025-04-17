@tool
class_name RaconteurScenarioNode extends Resource


@export var id: int
@export var label: StringName
@export var lines: Array[RaconteurLine]
@export var constraints: Array[RaconteurConstraint]
@export var next: Array[int]
@export var instructions: Array[RaconteurInstructionAliased]


func line_add(new_line: RaconteurLine) -> void:
    lines.append(new_line)


func constraint_add(new_constraint: RaconteurConstraint) -> void:
    constraints.append(new_constraint)


func next_add(next_id: int) -> void:
    next.append(next_id)


func instruction_add(instruction_name: StringName, aliased_args: Array) -> void:
    instructions.append(RaconteurInstructionAliased.new(instruction_name, aliased_args))