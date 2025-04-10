class_name RaconteurConstraintHasRelationship extends RaconteurConstraint


var alias_a: StringName
var alias_b: StringName
var relationship: StringName
var qualifier_value: StringName


func _init(alias_a_: StringName, relationship_: StringName, alias_b_: StringName, qualifier_value_: StringName = &"") -> void:
	alias_a = alias_a_
	alias_b = alias_b_
	relationship = relationship_
	qualifier_value = qualifier_value_


func is_satisfied(world: RaconteurWorld, binds: Dictionary[StringName, StringName]) -> bool:
	var entity_a_key := binds[alias_a]
	var entity_b_key := binds[alias_b]
	return world.relationship_has(entity_a_key, relationship, entity_b_key, qualifier_value)
