extends Node3D
class_name TableTop

func get_mesh() -> Mesh:
	return get_child(0).get_child(0).get_mesh()

func get_color() -> Color:
	return get_mesh().surface_get_material(0).albedo_color

func get_mesh_instance3D() -> MeshInstance3D:
	return get_child(0).get_child(0)

func get_base() -> Vector3:
	# the origin of the leg is in the center, and we want the bottom/base position
	# so we need to move it down by half the height
	return position

func get_top() -> Vector3:
	return position + Vector3(0, get_aabb().size.y, 0)

func scale_mesh(new_scale : Vector3) -> void:
	get_mesh_instance3D().scale = new_scale

func get_mesh_scale() -> Vector3:
	return get_mesh_instance3D().scale

func get_aabb() -> AABB:
	var aabb = get_mesh().get_aabb()
	aabb.size *= get_mesh_instance3D().scale
	return aabb
