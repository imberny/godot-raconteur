extends GutTest


func test_schema():
	var schema := RaconteurSchema.new()

	var quality_enum := &"quality"
	var quality_values := [&"shoddy", &"good", &"superior"]
	schema.enum_add(quality_enum, quality_values)
	var relation_enum := &"relation"
	var relation_values := [&"friend", &"enemy"]
	schema.enum_add(relation_enum, relation_values)
	var enums := schema.enums()
	assert_eq(enums, {
		quality_enum: quality_values,
		relation_enum: relation_values,
	})
	assert_eq(schema.enum_validate(quality_enum, &"shoddy"), "")
	assert_eq(schema.enum_validate(relation_enum, &"friend"), "")
	assert_ne(schema.enum_validate(relation_enum, &"invalid_value"), "") # invalid

	schema.property_add(&"name", RaconteurProperty.Type.STRING)
	assert_eq(schema.property_add(&"quality", RaconteurProperty.Type.ENUM, &"quality"), "")
	schema.property_add(&"speech", RaconteurProperty.Type.STRING)
	assert_eq(schema.property_get(&"name").type(), RaconteurProperty.Type.STRING)
	assert_eq(schema.property_get(&"quality").type(), RaconteurProperty.Type.ENUM)
	assert_eq(schema.property_get(&"quality").enum_name(), &"quality")

	schema.entity_add(&"item", [&"name", &"quality"])
	schema.entity_add(&"character", [&"name"])
	assert_eq(schema.entity_get(&"item"), [&"name", &"quality"])
	assert_eq(schema.entity_get(&"character"), [&"name"])
	var errors := RaconteurEntity.validate(schema, &"bad_sword", &"item", {&"name": "Sword", &"quality": &"shoddy"})
	assert_true(errors.is_empty())
	errors = RaconteurEntity.validate(schema, &"invalid sword", &"item", {&"name": &"Sword", &"quality": &"invalid_quality"})
	assert_false(errors.is_empty())

	schema.tag_add(&"stolen")
	var tags := schema.tags()
	assert_eq(tags, [&"stolen"])

	schema.relationship_descriptor_add(&"character", &"owns", &"item")
	schema.relationship_descriptor_add(&"character", &"knows", &"character", &"relation")
	schema.relationship_descriptor_add(&"character", &"knows", &"item")
	assert_eq(schema.relationship_descriptors_get_between(&"character", &"item"), [&"owns", &"knows"])
	assert_eq(schema.relationship_descriptor_get(&"character", &"knows", &"item").qualifier_enum, &"")
	assert_eq(schema.relationship_descriptor_get(&"character", &"knows", &"character").qualifier_enum, &"relation")

	var speak_callback := func(_speaker: String, _listener: String, _speech: String): pass
	var invalid_callback := func(_first: String, _second: String): pass
	var speak_instruction := &"speak"
	var speak_args := [&"character", &"character", &"speech"]
	schema.instruction_add(speak_instruction, speak_args)
	assert_ne(schema.instruction_set_callback(speak_instruction, invalid_callback), "") # invalid
	assert_eq(schema.instruction_set_callback(speak_instruction, speak_callback), "")
	var expected_instruction := RaconteurInstruction.new(speak_instruction, speak_args)
	expected_instruction.callback = speak_callback
	assert_true(schema.instruction_get(speak_instruction).is_eq(expected_instruction))
