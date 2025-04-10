class_name RaconteurScenarioNode extends Resource


@export var id: int
@export var label: StringName
@export var lines: Array[RaconteurLine]
@export var constraints: Array[RaconteurConstraint]
@export var next: Array[RaconteurScenarioNode]


func _init(id_: int) -> void:
    id = id_


func line_add(new_line: RaconteurLine) -> void:
    lines.append(new_line)


func constraint_add(new_constraint: RaconteurConstraint) -> void:
    constraints.append(new_constraint)


func next_add(next_node: RaconteurScenarioNode) -> void:
    next.append(next_node)