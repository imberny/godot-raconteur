class_name RaconteurConstraintSameRelationship extends RaconteurConstraint


var alias_a: StringName
var alias_b: StringName
var relationship_name: StringName
var alias_c: StringName


func _init(alias_a_: StringName, alias_b_: StringName, relationship_name_: StringName, alias_c_: StringName) -> void:
	alias_a = alias_a_
	alias_b = alias_b_
	relationship_name = relationship_name_
	alias_c = alias_c_


func is_satisfied(world: RaconteurWorld, binds: Dictionary[StringName, StringName]) -> bool:
	var entity_a_key := binds[alias_a]
	var entity_b_key := binds[alias_b]
	var entity_c_key := binds[alias_c]

	var have_both_a_relationship_with_c := world.relationship_has(entity_a_key, relationship_name, entity_c_key) and world.relationship_has(entity_b_key, relationship_name, entity_c_key)
	if not have_both_a_relationship_with_c:
		return false

	var relationship_a := world.relationship_get(entity_a_key, relationship_name, entity_c_key)
	var relationship_b := world.relationship_get(entity_b_key, relationship_name, entity_c_key)
	return relationship_a.qualifier_value == relationship_b.qualifier_value
