class_name RaconteurWorld


var _schema: RaconteurSchema
var _entities: Dictionary[StringName, Dictionary] = {}


func _init(schema: RaconteurSchema) -> void:
    _schema = schema


func entity_add(name: StringName, properties: Dictionary) -> Array:
    var errors := _schema.entity_validate(name, properties)
    if not errors.is_empty():
        return errors
    
    _entities[name] = properties
    return []


func relationship_add(
    entity_a: StringName,
    entity_b: StringName,
    relationship_name: StringName,
    qualifier_value: StringName = "",
) -> void:
    pass