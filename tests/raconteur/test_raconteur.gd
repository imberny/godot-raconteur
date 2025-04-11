extends GutTest

const COMMON: GDScript = preload("res://tests/raconteur/common.gd")


func test_raconteur():
    var schema: RaconteurSchema = COMMON.schema()
    var world: RaconteurWorld = COMMON.world(schema)

    var raconteur := Raconteur.new(schema)
    for beat in COMMON.beats():
        raconteur.beat_add(beat)

    var beats := raconteur.query(world)
    assert_eq(len(beats), 1)