extends GutTest


func test_schema():
    var schema := RaconteurSchema.new()

    var quality_enum := &"quality"
    var quality_values := [&"shoddy", &"good", &"superior"]
    schema.enum_add(quality_enum, quality_values)
    var enums := schema.enums()
    assert_eq(enums, {quality_enum: quality_values})

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
    var entities := schema.entities()
    assert_eq(entities, {
        &"item": [&"name", &"quality"],
        &"character": [&"name"],
    })

    schema.flag_add(&"stolen")
    var flags := schema.flags()
    assert_eq(flags, [&"stolen"])

    schema.relationship_add(&"item", &"character", &"owner")
    var relationships := schema.relationships()
    assert_eq(relationships[[&"item", &"character"]], &"owner")

    var speak_callback := func(_speaker: String, _listener: String, _speech: String): pass
    var speak_instruction := &"speak"
    var speak_args := [&"character", &"character", &"speech"]
    schema.instruction_add(speak_instruction, speak_args)
    schema.instruction_set_callback(speak_instruction, speak_callback)
    var instructions := schema.instructions()
    var expected_instruction := RaconteurInstruction.new(speak_instruction, speak_args)
    expected_instruction.callback = speak_callback
    assert_true(instructions[speak_instruction].is_eq(expected_instruction))

    schema.global_entity_add(&"PROTAGONIST", &"character")
    assert_eq(schema.global_entities()[&"PROTAGONIST"], &"character")
