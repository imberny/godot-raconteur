class_name RaconteurSchema extends Resource

enum Type {
    ENUM,
    ENTITY,
    INT,
    STRING,
    BOOL,
}

var _enums: Dictionary[StringName, Array] = {}
var _properties: Dictionary[StringName, Type] = {}
var _entities: Dictionary[StringName, Array] = {}
var _flags: Array = []
var _relationships: Dictionary[Array, StringName] = {}
var _instructions: Dictionary[StringName, RaconteurInstruction] = {}
var _global_entities: Dictionary[StringName, StringName] = {}


func enum_add(name: StringName, values: Array) -> void:
    _enums[name] = values


func enums() -> Dictionary:
    return _enums


func property_add(name: StringName, type: Type) -> void:
    _properties[name] = type


func properties() -> Dictionary:
    return _properties


func entity_add(name: StringName, entity_properties: Array) -> void:
    _entities[name] = entity_properties


func entities() -> Dictionary:
    return _entities


func flag_add(name: StringName) -> void:
    _flags.push_back(name)


func flags() -> Array:
    return _flags


func relationship_add(entity_a: StringName, entity_b: StringName, relationship: StringName) -> void:
    _relationships[[entity_a, entity_b]] = relationship


func relationships() -> Dictionary:
    return _relationships


func instruction_add(name: StringName, args: Array) -> void:
    _instructions[name] = RaconteurInstruction.new(name, args)


func instruction_set_callback(name: StringName, callback: Callable) -> void:
    var instruction = _instructions[name]
    if len(instruction.args) != callback.get_argument_count():
        push_error(
            "Argument count mismatch for instruction callback '%s': expected %d, got %d"
            % [name, len(instruction.args), callback.get_argument_count()]
        )
        return
    instruction.callback = callback


func instructions() -> Dictionary:
    return _instructions


func global_entity_add(name: StringName, entity_type: StringName) -> void:
    _global_entities[name] = entity_type


func global_entities() -> Dictionary:
    return _global_entities