class_name RaconteurConstraint extends Resource


func _init() -> void:
    assert(false, "RaconteurConstraint is an abstract class and should not be instantiated directly.")


func is_satisfied(_world: RaconteurWorld, _binds: Dictionary[StringName, StringName]) -> bool:
    assert(false, "Method not implemented.")
    return false