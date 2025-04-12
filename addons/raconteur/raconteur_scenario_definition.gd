class_name RaconteurScenarioDefinition extends Resource


@export var aliases: Dictionary[StringName, StringName] = {}
@export var new_entities: Dictionary[StringName, RaconteurEntity] = {}
@export var new_relationships: Array[RaconteurRelationship] = []
@export var constraints: Array[RaconteurConstraint] = []
@export var scenario_nodes: Dictionary[int, RaconteurScenarioNode] = {}
@export var start_node: int


var _id_count := 0


func alias_add(alias: StringName, entity_type: StringName) -> void:
    aliases[alias] = entity_type


func alias_add_new_entity(entity_type: StringName, name: StringName, properties: Dictionary) -> void:
    var new_entity := RaconteurEntity.new(entity_type, name, properties)
    new_entities[name] = new_entity


func new_relationship(entity_a: StringName, entity_b: StringName, relationship: StringName) -> void:
    new_relationships.push_back(RaconteurRelationship.new(relationship, entity_a, entity_b))


func constraint_add(constraint: RaconteurConstraint) -> void:
    constraints.push_back(constraint)


func scenario_node_create() -> RaconteurScenarioNode:
    var node := RaconteurScenarioNode.new(_id_count)
    _id_count += 1
    scenario_nodes[node.id] = node
    return node


func scenario_node_delete(id: int) -> void:
    if scenario_nodes.has(id):
        scenario_nodes.erase(id)


func scenario_set_start_node(id: int) -> String:
    if not scenario_nodes.has(id):
        return "Scenario node with id %s not found." % id
    start_node = id
    return ""