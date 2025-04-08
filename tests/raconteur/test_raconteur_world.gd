extends GutTest


func test_world():
	var schema := RaconteurSchema.new()
	schema.enum_add(&"relation", [&"friend", &"enemy"])
	schema.property_add(&"name", RaconteurProperty.Type.STRING)
	schema.entity_add(&"character", [&"name"])
	schema.relationship_add(&"knows", &"character", &"character")

	var world := RaconteurWorld.new(schema)

	assert_eq(world.entity_add(&"character", &"alice", {"name": &"Alice"}), [])
	assert_eq(world.entity_add(&"character", &"bob", {"name": &"Bob"}), [])
	assert_eq(world.relationship_add(&"alice", &"bob", &"knows", &"friend"), [])
	assert_ne(world.relationship_add(&"alice", &"bob", &"owns"), []) # invalid


	world.global_entity_add(&"character", &"PROTAGONIST", {})
	assert_eq(world.global_entity_get(&"PROTAGONIST").type(), &"character")
