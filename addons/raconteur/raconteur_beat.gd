class_name RaconteurBeat extends Resource


@export var aliases: Dictionary[StringName, StringName] = {}
@export var new_entities: Dictionary[StringName, RaconteurEntity] = {}
@export var new_relationships: Array[RaconteurRelationship] = []
@export var constraints: Array[RaconteurConstraint] = []


func alias_add(alias: StringName, entity_type: StringName) -> void:
    aliases[alias] = entity_type


func alias_add_new_entity(entity_type: StringName, name: StringName, properties: Dictionary) -> void:
    var new_entity := RaconteurEntity.new(entity_type, name, properties)
    new_entities[name] = new_entity


func new_relationship(entity_a: StringName, entity_b: StringName, relationship: StringName) -> void:
    new_relationships.push_back(RaconteurRelationship.new(relationship, entity_a, entity_b))


func constraint_add(constraint: RaconteurConstraint) -> void:
    constraints.push_back(constraint)