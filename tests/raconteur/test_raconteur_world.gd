extends GutTest


func test_world():
    var schema := RaconteurSchema.new()
    schema.property_add(&"name", RaconteurSchema.Type.STRING)
    schema.entity_add(&"character", [&"name"])

    var world := RaconteurWorld.new()

    assert_true(true)
