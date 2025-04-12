class_name RaconteurEntity extends Resource

@export var key: StringName
@export var type: StringName
@export var properties: Dictionary = {}
@export var tags: Array[StringName] = []


static func validate(schema: RaconteurSchema, key_: StringName, type_: StringName, properties: Dictionary) -> Array:
	var errors := []
	if not schema.entity_has(type_):
		errors.append("Entity type '%s' not found" % type_)
	for property_name in properties.keys():
		var property_value: Variant = properties[property_name]
		var error := schema.property_validate(property_name, property_value)
		if not error.is_empty():
			errors.append(error)
	return errors


func _init(key_: StringName, type_: StringName, properties_: Dictionary) -> void:
	key = key_
	type = type_
	properties = properties_


func property_list() -> Dictionary:
	return properties


func property_value(property_name: StringName) -> Variant:
	return properties.get(property_name, null)


func tag_has(tag: StringName) -> bool:
	return tags.has(tag)


func tag_add(tag: StringName) -> void:
	if not tags.has(tag):
		tags.append(tag)


func tag_remove(tag: StringName) -> void:
	if tags.has(tag):
		tags.erase(tag)
