extends GutTest


func world_setup() -> RaconteurWorld:
	var schema := RaconteurSchema.new()
	schema.property_add(&"name", RaconteurProperty.Type.STRING)
	schema.entity_add(&"character", [&"name"])
	schema.relationship_descriptor_add(&"character", &"knows", &"character")
	schema.tag_add(&"pretty")

	var world := RaconteurWorld.new(schema)
	world.entity_add(&"character", &"alice", {"name": &"Alice"})
	world.entity_add(&"character", &"bob", {"name": &"Bob"})
	world.relationship_add(&"alice", &"knows", &"bob")

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

	var relationship_constraint := RaconteurConstraintHasRelationship.new(&"woman", &"knows", &"bus driver")
	var binds: Dictionary[StringName, StringName] = {&"woman": &"alice", &"bus driver": &"bob"}
	assert_true(relationship_constraint.is_satisfied(world, binds))
