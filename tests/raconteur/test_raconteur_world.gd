extends GutTest


func test_world():
	var schema := RaconteurSchema.new()
	schema.enum_add(&"relation", [&"friend", &"enemy"])
	schema.property_add(&"name", RaconteurProperty.Type.STRING)
	schema.entity_add(&"character", [&"name"])
	schema.entity_add(&"item", [&"name"])
	schema.relationship_descriptor_add(&"character", &"knows", &"character")
	schema.relationship_descriptor_add(&"character", &"owns", &"item")
	schema.tag_add(&"pretty")

	var world := RaconteurWorld.new(schema)

	assert_eq(world.entity_add(&"character", &"alice", {"name": &"Alice"}), [])
	assert_eq(world.entity_add(&"character", &"bob", {"name": &"Bob"}), [])
	assert_eq(world.relationship_add(&"alice", &"knows", &"bob", &"friend"), [])
	assert_ne(world.relationship_add(&"alice", &"owns", &"bob", ), []) # invalid
	assert_true(world.relationship_has(&"alice", &"knows", &"bob"))
	assert_true(world.relationship_has(&"alice", &"knows", &"bob", &"friend"))
	assert_false(world.relationship_has(&"alice", &"knows", &"bob", &"enemy"))
	assert_false(world.relationship_has(&"alice", &"owns", &"bob"))


	world.global_entity_add(&"character", &"PROTAGONIST", {})
	assert_eq(world.global_entity_get(&"PROTAGONIST").type(), &"character")

	assert_eq(world.entity_tag(&"alice", &"pretty"), "")
	assert_true(world.entity_get(&"alice").tag_has(&"pretty"))

	assert_eq(world.entity_untag(&"alice", &"pretty"), "")
	assert_false(world.entity_get(&"alice").tag_has(&"pretty"))
