extends Node3D
class_name TableLeg

func get_mesh() -> Mesh:
	return get_child(0).get_child(0).get_mesh()

func get_mesh_instance3D() -> MeshInstance3D:
	return get_child(0).get_child(0)

func get_color() -> Color:
	return get_mesh().surface_get_material(0).albedo_color

func get_base() -> Vector3:
	return position

func get_top() -> Vector3:
	return position + Vector3(0, get_aabb().size.y, 0)

func scale_mesh(new_scale : Vector3) -> void:
	get_mesh_instance3D().scale = new_scale

func get_mesh_scale() -> Vector3:
	return get_mesh_instance3D().scale

func set_y_scale(new_y_scale : float) -> void:
	get_child(0).scale.y = new_y_scale

func set_x_scale(new_x_scale : float) -> void:
	get_child(0).scale.x = new_x_scale

func set_x_z_scale(new_x_z_scale : float) -> void:
	var child = get_child(0)
	child.scale.x = new_x_z_scale
	child.scale.z = new_x_z_scale

func get_aabb() -> AABB:
	var aabb = get_mesh().get_aabb()
	aabb.size *= get_mesh_instance3D().scale
	return aabb
