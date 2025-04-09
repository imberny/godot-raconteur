class_name RaconteurEntity extends Resource

var _key: StringName
var _type: StringName
var _properties: Dictionary = {}
var _tags: Array[StringName] = []


static func validate(schema: RaconteurSchema, key: StringName, type: StringName, properties: Dictionary) -> Array:
    var errors := []
    if not schema.entity_has(type):
        errors.append("Entity type '%s' not found" % type)
    for property_name in properties.keys():
        var property_value: Variant = properties[property_name]
        var error := schema.property_validate(property_name, property_value)
        if not error.is_empty():
            errors.append(error)
    return errors


func _init(key: StringName, type: StringName, properties: Dictionary) -> void:
    _key = key
    _type = type
    _properties = properties


func type() -> StringName:
    return _type


func key() -> StringName:
    return _key


func properties() -> Dictionary:
    return _properties


func tags() -> Array[StringName]:
    return _tags


func tag_has(tag: StringName) -> bool:
    return _tags.has(tag)


func tag_add(tag: StringName) -> void:
    if not _tags.has(tag):
        _tags.append(tag)


func tag_remove(tag: StringName) -> void:
    if _tags.has(tag):
        _tags.erase(tag)