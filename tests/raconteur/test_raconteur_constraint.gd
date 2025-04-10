extends GutTest


func world_setup() -> RaconteurWorld:
	var schema := RaconteurSchema.new()
	schema.enum_add(&"genders", [&"male", &"female"])
	schema.enum_add(&"wealth levels", [&"destitute", &"poor", &"well off", &"rich", &"opulent"])
	schema.enum_add(&"friendliness", [&"enemy", &"rival", &"neutral", &"friend", &"ally"])
	schema.property_add(&"name", RaconteurProperty.Type.STRING)
	schema.property_add(&"gender", RaconteurProperty.Type.ENUM, &"genders")
	schema.property_add(&"age", RaconteurProperty.Type.INT)
	schema.property_add(&"wealth", RaconteurProperty.Type.ENUM, &"wealth levels")
	schema.entity_add(&"character", [&"name", &"gender", &"age", &"wealth"])
	schema.entity_add(&"city", [&"name"])
	schema.relationship_descriptor_add(&"character", &"knows", &"character", &"friendliness")
	schema.relationship_descriptor_add(&"character", &"in", &"city")
	schema.tag_add(&"pretty")

	var world := RaconteurWorld.new(schema)
	world.entity_add(&"character", &"alice", {
		&"name": &"Alice",
		&"gender": &"female",
		&"age": 30,
		&"wealth": &"rich",
	})
	world.entity_add(&"character", &"bob", {
		"name": &"Bob",
		&"gender": &"male",
		"age": 25,
		"wealth": &"poor",
	})
	world.entity_add(&"city", &"rotterdam", {
		"name": &"Rotterdam",
	})
	world.relationship_add(&"alice", &"knows", &"bob", &"neutral")
	world.relationship_add(&"alice", &"in", &"rotterdam")
	world.relationship_add(&"bob", &"in", &"rotterdam")

	return world


func test_constraint_tag():
	var world := world_setup()
	
	var tag_constraint := RaconteurConstraintHasTag.new(&"pretty woman", &"pretty")
	var binds: Dictionary[StringName, StringName] = {&"pretty woman": &"alice"}
	world.entity_tag(&"alice", &"pretty")

	assert_true(tag_constraint.is_satisfied(world, binds))

	world.entity_untag(&"alice", &"pretty")
	assert_false(tag_constraint.is_satisfied(world, binds))


func test_constraint_relationship():
	var world := world_setup()

	var relationship_constraint := RaconteurConstraintHasRelationship.new(&"woman", &"knows", &"bus driver", &"neutral")
	var binds: Dictionary[StringName, StringName] = {&"woman": &"alice", &"bus driver": &"bob"}
	assert_true(relationship_constraint.is_satisfied(world, binds))


func test_constraint_compare():
	var world := world_setup()

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
	var world := world_setup()

	var binds: Dictionary[StringName, StringName] = {
		&"rich woman": &"alice",
		&"poor man": &"bob",
	}

	var one_of_constraint := RaconteurConstraintSet.new(&"rich woman", &"wealth", RaconteurConstraintSet.Operator.ONE_OF, [&"rich", &"opulent"])
	assert_true(one_of_constraint.is_satisfied(world, binds))

	var none_of_constraint := RaconteurConstraintSet.new(&"poor man", &"wealth", RaconteurConstraintSet.Operator.NONE_OF, [&"well off", &"rich", &"opulent"])
	assert_true(none_of_constraint.is_satisfied(world, binds))


func test_constraint_same_relationship():
	var world := world_setup()

	var binds: Dictionary[StringName, StringName] = {
		&"customer": &"alice",
		&"merchant": &"bob",
		&"city": &"rotterdam",
	}

	var same_relationship_constraint := RaconteurConstraintSameRelationship.new(&"customer", &"merchant", &"in", &"city")
	assert_true(same_relationship_constraint.is_satisfied(world, binds))
