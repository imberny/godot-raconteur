class_name RaconteurSchema extends Resource

enum Type {
    ENUM,
    ENTITY,
    INT,
    STRING,
    BOOL,
}

class Instruction:
    var name: String
    var args: Array
    var callback: Callable
    func _init(name_: String, args_: Array) -> void:
        name = name_
        args = args_
    
    func is_eq(other: Instruction) -> bool:
        return name == other.name and args == other.args and callback == other.callback

var _enums: Dictionary[String, Array] = {}
var _properties: Dictionary[String, Type] = {}
var _entities: Dictionary[String, Array] = {}
var _flags: Array = []
var _relationships: Dictionary[Array, String] = {}
var _instructions: Dictionary[String, Instruction] = {}
var _global_entities: Dictionary[String, String] = {}


func enum_add(name: String, values: Array) -> void:
    _enums[name] = values


func enums() -> Dictionary:
    return _enums


func property_add(name: String, type: Type) -> void:
    _properties[name] = type


func properties() -> Dictionary:
    return _properties


func entity_add(name: String, entity_properties: Array) -> void:
    _entities[name] = entity_properties


func entities() -> Dictionary:
    return _entities


func flag_add(name: String) -> void:
    _flags.push_back(name)


func flags() -> Array:
    return _flags


func relationship_add(entity_a: String, entity_b: String, relationship: String) -> void:
    _relationships[[entity_a, entity_b]] = relationship


func relationships() -> Dictionary:
    return _relationships


func instruction_add(name: String, args: Array) -> void:
    _instructions[name] = Instruction.new(name, args)


func instruction_set_callback(name: String, callback: Callable) -> void:
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


func global_entity_add(name: String, entity_type: String) -> void:
    _global_entities[name] = entity_type


func global_entities() -> Dictionary:
    return _global_entities