class_name RaconteurEntity


var _key: StringName
var _type: StringName
var _properties: Dictionary = {}


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