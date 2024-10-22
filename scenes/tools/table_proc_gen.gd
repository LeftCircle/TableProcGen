extends Node3D
class_name TableProcGen

@export var footprint : Vector3 = Vector3(10, 5, 3)
@export var legs : Array[String] = []
@export var tops : Array[String] = []
@export_range(0, 10, 0.01) var max_leg_edge_offset : float = 0.5


var _top_in_scene : TableTop = null
var _legs_in_scene : Array[TableLeg] = []

func _ready() -> void:
	build_table()

func _input(event : InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("enter"):
			build_table()

func build_table() -> void:
	await _reset()
	var topc : Color = ColorIDs.get_random_color()
	var legc : Color = ColorIDs.get_random_color_other_than(topc)
	_generate_top(topc)
	_generate_legs(legc)

func _generate_top(color : Color) -> void:
	_top_in_scene = get_top()
	set_mesh_color(_top_in_scene.get_mesh(), color)
	_top_in_scene.position = Vector3(footprint.x/2, footprint.y + 0.05, footprint.z/2)
	add_child(_top_in_scene)
	_scale_top()

func _scale_top() -> void:
	var og_scale = _top_in_scene.get_mesh_scale()
	_top_in_scene.scale_mesh(Vector3.ONE)
	var top_aabb = _top_in_scene.get_aabb()
	# scale the x and z to fit the footprint and keep the y height
	var x_scale = footprint.x / top_aabb.size.x
	var z_scale = footprint.z / top_aabb.size.z
	og_scale.x = x_scale
	og_scale.z = z_scale
	_top_in_scene.scale_mesh(og_scale)

func _generate_legs(color : Color) -> void:
	var leg_path = get_random_leg_path()
	var leg = get_leg_with_path(leg_path)
	add_child(leg)
	set_mesh_color(leg.get_mesh(), color)
	_legs_in_scene.append(leg)
	if leg is SingleLeg:
		for i in range(3):
			var other_leg = get_leg_with_path(leg_path)
			add_child(other_leg)
			set_mesh_color(other_leg.get_mesh(), color)
			_legs_in_scene.append(other_leg)
	else:
		assert(false, "Only support for single legs at the moment")
	_position_legs()
	_scale_legs_height()

func _position_legs() -> void:
	var offset = randf_range(0.1, max_leg_edge_offset)
	if _legs_in_scene[0] is SingleLeg:
		_legs_in_scene[0].position = Vector3.ZERO + Vector3(offset, 0, 0).rotated(Vector3(0, 1, 0), -PI / 4)
		_legs_in_scene[1].position = Vector3(0, 0, footprint.z) + Vector3(offset, 0, 0).rotated(Vector3(0, 1, 0), PI / 4)
		_legs_in_scene[2].position = Vector3(footprint.x, 0, 0) + Vector3(offset, 0, 0).rotated(Vector3(0, 1, 0), 5 * PI / 4)
		_legs_in_scene[3].position = Vector3(footprint.x, 0, footprint.z) + Vector3(offset, 0, 0).rotated(Vector3(0, 1, 0), 3 * PI / 4)

func _scale_legs_height() -> void:
	var leg_height = _legs_in_scene[0].get_aabb().size.y
	var y_scale = footprint.y / leg_height
	for leg in _legs_in_scene:
		leg.set_y_scale(y_scale)

func _reset() -> void:
	if is_instance_valid(_top_in_scene):
		_top_in_scene.queue_free()
		_top_in_scene = null
	for leg in _legs_in_scene:
		if is_instance_valid(leg):
			leg.queue_free()
	_legs_in_scene.clear()
	await get_tree().process_frame

func get_leg() -> TableLeg:
	return load(legs[randi() % legs.size()]).instantiate()

func get_leg_with_path(path : String) -> TableLeg:
	return load(path).instantiate()

func get_random_leg_path() -> String:
	return legs[randi() % legs.size()]

func get_top() -> TableTop:
	return load(tops[randi() % tops.size()]).instantiate()

func get_color() -> Color:
	return ColorIDs.COLORS[randi() % ColorIDs.COLORS.size()]

func set_mesh_color(mesh : Mesh, color : Color) -> void:
	var material : StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = color
	mesh.surface_set_material(0, material)

func get_top_in_tree() -> TableTop:
	return _top_in_scene

func get_legs_in_tree() -> Array[TableLeg]:
	return _legs_in_scene
