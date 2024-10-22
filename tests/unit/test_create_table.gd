extends GutTest

var table_pg_path = "res://scenes/tools/table_proc_gen.tscn"

func test_table_creation_attributes():
	var table_pg : TableProcGen = TableProcGen.new()
	assert_true(table_pg.footprint != null)
	assert_true(table_pg.legs != null)
	assert_true(table_pg.tops != null)

func test_colors():
	var hex : Color =  Color('#F8A81A')
	var rgba : Color = Color(248.0/255, 168.0/255, 26.0/255)
	assert_eq(hex, rgba, "Colors must match")

func test_set_color():
	var pg : TableProcGen = load(table_pg_path).instantiate()
	var leg : TableLeg = pg.get_leg()
	var color : Color = pg.get_color()
	pg.set_mesh_color(leg.get_mesh(), color)
	assert_eq(leg.get_color(), color)

func test_legs_and_table_enter_scene() -> void:
	var pg : TableProcGen = load(table_pg_path).instantiate()
	add_child(pg)
	pg.build_table()
	var top = pg.get_top_in_tree()
	assert_true(top.is_inside_tree())
	var legs = pg.get_legs_in_tree()
	for leg in legs:
		assert_true(leg.is_inside_tree())
	pg.queue_free()

func test_legs_are_near_ends() -> void:
	# check that the distance from the legs to the end of the
	# footprint is less than some max distance
	var pg : TableProcGen = load(table_pg_path).instantiate()
	add_child(pg)
	pg.build_table()
	var l1_expected = Vector3.ZERO
	var l2_expected = Vector3(0, 0, pg.footprint.z)
	var l3_expected = Vector3(pg.footprint.x, 0, 0)
	var l4_expected = Vector3(pg.footprint.x, 0, pg.footprint.z)
	var legs : Array[TableLeg] = pg.get_legs_in_tree()

	var l1_end = legs[0].get_base()
	var l2_end = legs[1].get_base()
	var l3_end = legs[2].get_base()
	var l4_end = legs[3].get_base()
	assert_true(l1_end.distance_to(l1_expected) < pg.max_leg_edge_offset)
	assert_true(l2_end.distance_to(l2_expected) < pg.max_leg_edge_offset)
	assert_true(l3_end.distance_to(l3_expected) < pg.max_leg_edge_offset)
	assert_true(l4_end.distance_to(l4_expected) < pg.max_leg_edge_offset)

	var l1_top_e = Vector3(0, pg.footprint.y, 0)
	var l2_top_e = Vector3(0, pg.footprint.y, pg.footprint.z)
	var l3_top_e = Vector3(pg.footprint.x, pg.footprint.y, 0)
	var l4_top_e = Vector3(pg.footprint.x, pg.footprint.y, pg.footprint.z)

	var l1_top = legs[0].get_top()
	var l2_top = legs[1].get_top()
	var l3_top = legs[2].get_top()
	var l4_top = legs[3].get_top()
	assert_almost_eq(l1_top, l1_top_e, Vector3(0.1, 0.1, 0.1))
	assert_true(l1_top.distance_to(l1_top_e) < pg.max_leg_edge_offset)
	assert_true(l2_top.distance_to(l2_top_e) < pg.max_leg_edge_offset)
	assert_true(l3_top.distance_to(l3_top_e) < pg.max_leg_edge_offset)
	assert_true(l4_top.distance_to(l4_top_e) < pg.max_leg_edge_offset)

	var top : TableTop = pg.get_top_in_tree()
	var expected_pos = Vector3(pg.footprint.x/2, pg.footprint.y, pg.footprint.z/2)
	assert_eq(top.position, expected_pos)
