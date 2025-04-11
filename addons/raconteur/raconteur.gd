## This class allows querying a list of possible beats for the given world.
class_name Raconteur


var schema: RaconteurSchema
var beats: Array[RaconteurBeat] = []


func _init(schema_: RaconteurSchema) -> void:
    schema = schema_


func beat_add(beat: RaconteurBeat) -> void:
    beats.append(beat)


func query(world: RaconteurWorld) -> Array[RaconteurBeat]:
    return beats