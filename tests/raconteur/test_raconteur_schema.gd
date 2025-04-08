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

    schema.property_add(&"name", RaconteurSchema.Type.STRING)
    schema.property_add(&"quality", RaconteurSchema.Type.ENUM)
    schema.property_add(&"speech", RaconteurSchema.Type.STRING)
    var properties := schema.properties()
    assert_eq(properties, {
        &"name": RaconteurSchema.Type.STRING,
        &"quality": RaconteurSchema.Type.ENUM,
        &"speech": RaconteurSchema.Type.STRING,
    })

    schema.entity_add(&"item", [&"name", &"quality"])
    schema.entity_add(&"character", [&"name"])
    assert_eq(schema.entity_get(&"item"), [&"name", &"quality"])
    assert_eq(schema.entity_get(&"character"), [&"name"])

    schema.tag_add(&"stolen")
    var tags := schema.tags()
    assert_eq(tags, [&"stolen"])

    schema.relationship_add(&"owns", &"character", &"item")
    schema.relationship_add(&"knows", &"character", &"character", &"relation")
    schema.relationship_add(&"knows", &"character", &"item")
    assert_eq(schema.relationships_get_between(&"character", &"item"), [&"owns", &"knows"])
    assert_eq(schema.relationship_get(&"knows", &"character", &"item").qualifier_property, &"")
    assert_eq(schema.relationship_get(&"knows", &"character", &"character").qualifier_property, &"relation")

    var speak_callback := func(_speaker: String, _listener: String, _speech: String): pass
    var speak_instruction := &"speak"
    var speak_args := [&"character", &"character", &"speech"]
    schema.instruction_add(speak_instruction, speak_args)
    schema.instruction_set_callback(speak_instruction, speak_callback)
    var expected_instruction := RaconteurInstruction.new(speak_instruction, speak_args)
    expected_instruction.callback = speak_callback
    assert_true(schema.instruction_get(speak_instruction).is_eq(expected_instruction))

    schema.global_entity_add(&"PROTAGONIST", &"character")
    assert_eq(schema.global_entities()[&"PROTAGONIST"], &"character")
