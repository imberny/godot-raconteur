extends GutTest


func test_world():
	var schema := RaconteurSchema.new()
	schema.enum_add(&"relation", [&"friend", &"enemy"])
	schema.property_add(&"name", RaconteurProperty.Type.STRING)
	schema.entity_add(&"character", [&"name"])
	schema.relationship_add(&"knows", &"character", &"character")

	var world := RaconteurWorld.new(schema)

	assert_eq(world.entity_add(&"character", {"name": &"Alice"}), [])
	assert_eq(world.entity_add(&"character", {"name": &"Bob"}), [])
	world.relationship_add(&"Alice", &"Bob", &"knows", &"friend")

	assert_true(true)
