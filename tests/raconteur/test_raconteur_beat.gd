extends GutTest


func test_beat():
    var beat := RaconteurBeat.new()

    beat.alias_add(&"merchant", &"character")

    beat.alias_add_new_entity(&"item", &"ring", {"name": &"Ring of Power", &"quality": &"superior"})

    beat.new_relationship(&"merchant", &"ring", &"owns")

    beat.constraint_add(RaconteurConstraintHasTag.new(&"PROTAGONIST", &"shopping"))
    
    assert_true(true)