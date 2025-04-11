extends GutTest

const COMMON: GDScript = preload("res://tests/raconteur/common.gd")


func test_constraint_tag():
    var schema: RaconteurSchema = COMMON.schema()
    var world: RaconteurWorld = COMMON.world(schema)
    
    var tag_constraint := RaconteurConstraintHasTag.new(&"pretty woman", &"pretty")
    var binds: Dictionary[StringName, StringName] = {&"pretty woman": &"alice"}
    world.entity_tag(&"alice", &"pretty")

    assert_true(tag_constraint.is_satisfied(world, binds))

    world.entity_untag(&"alice", &"pretty")
    assert_false(tag_constraint.is_satisfied(world, binds))


func test_constraint_relationship():
    var schema: RaconteurSchema = COMMON.schema()
    var world: RaconteurWorld = COMMON.world(schema)

    var relationship_constraint := RaconteurConstraintHasRelationship.new(&"woman", &"knows", &"bus driver", &"neutral")
    var binds: Dictionary[StringName, StringName] = {&"woman": &"alice", &"bus driver": &"bob"}
    assert_true(relationship_constraint.is_satisfied(world, binds))


func test_constraint_compare():
    var schema: RaconteurSchema = COMMON.schema()
    var world: RaconteurWorld = COMMON.world(schema)

    var binds: Dictionary[StringName, StringName] = {
        &"woman": &"alice",
        &"man": &"bob",
    }

    var equals_constraint := RaconteurConstraintCompare.new(&"woman", &"gender", RaconteurConstraintCompare.Operator.EQUALS, &"female")
    assert_true(equals_constraint.is_satisfied(world, binds))

    var greater_than_constraint := RaconteurConstraintCompare.new(&"woman", &"age", RaconteurConstraintCompare.Operator.GREATER_THAN, 20)
    assert_true(greater_than_constraint.is_satisfied(world, binds))

    var greater_than_other_property_constraint := RaconteurConstraintCompare.new(
        &"woman", &"age", RaconteurConstraintCompare.Operator.GREATER_THAN, &"man", &"age"
    )
    assert_true(greater_than_other_property_constraint.is_satisfied(world, binds))


func test_constraint_set():
    var schema: RaconteurSchema = COMMON.schema()
    var world: RaconteurWorld = COMMON.world(schema)

    var binds: Dictionary[StringName, StringName] = {
        &"rich woman": &"alice",
        &"poor man": &"bob",
    }

    var one_of_constraint := RaconteurConstraintSet.new(&"rich woman", &"wealth", RaconteurConstraintSet.Operator.ONE_OF, [&"rich", &"opulent"])
    assert_true(one_of_constraint.is_satisfied(world, binds))

    var none_of_constraint := RaconteurConstraintSet.new(&"poor man", &"wealth", RaconteurConstraintSet.Operator.NONE_OF, [&"well off", &"rich", &"opulent"])
    assert_true(none_of_constraint.is_satisfied(world, binds))


func test_constraint_same_relationship():
    var schema: RaconteurSchema = COMMON.schema()
    var world: RaconteurWorld = COMMON.world(schema)

    var binds: Dictionary[StringName, StringName] = {
        &"customer": &"alice",
        &"merchant": &"bob",
        &"city": &"rotterdam",
    }

    var same_relationship_constraint := RaconteurConstraintSameRelationship.new(&"customer", &"merchant", &"in", &"city")
    assert_true(same_relationship_constraint.is_satisfied(world, binds))
