class_name RaconteurConstraintHasTag extends RaconteurConstraint

var alias: StringName
var tag: StringName

func _init(alias_: StringName, tag_: StringName) -> void:
	alias = alias_
	tag = tag_


func is_satisfied(world: RaconteurWorld, binds: Dictionary[StringName, StringName]) -> bool:
	var entity_key := binds[alias]
	var entity := world.entity_get(entity_key)
	if not entity:
		return false
	return entity.tag_has(tag)
