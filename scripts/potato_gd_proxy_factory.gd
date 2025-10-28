extends ORC_ProxyFactory
class_name ORC_PotatoGDProxyFactory

func create_proxy_from_override(node : Node) -> ORC_ProxyObject:
	var proxy_object : ORC_ProxyObject = null
	if node is Camera3D:
		proxy_object = ORC_PotatoGD_CameraProxy.new()
	elif node is MeshInstance3D:
		proxy_object = ORC_PotatoGD_MeshProxy.new()
	return proxy_object
	
func create_data_from_override(node : Node, cache : ORC_ProxyCache) -> ORC_PrimaryData:
	var primary_data : ORC_PrimaryData = null
	if node is Camera3D:
		primary_data = create_camera_data_from(node, cache)
	elif node is MeshInstance3D:
		primary_data = create_mesh_data_from(node, cache)	
	return primary_data;

func create_camera_data_from(cam_node : Camera3D, cache : ORC_ProxyCache) -> ORC_PotatoGD_CameraData:
	var cam_data : ORC_PotatoGD_CameraData = create_and_register_primary(ORC_PotatoGD_CameraData, cache)
	cam_data.view_transform = cam_node.get_camera_transform().affine_inverse()
	cam_data.view_matrix_bytes = proj_to_bytes(Projection(cam_data.view_transform))
	cam_data.projection_matrix_bytes = proj_to_bytes(cam_node.get_camera_projection().flipped_y())

	var bytes = cam_data.view_matrix_bytes
	bytes.append_array(cam_data.projection_matrix_bytes)

	cam_data.matrices_uniform_buffer = ORC.rd.uniform_buffer_create(bytes.size(), bytes)
	return cam_data
	
func create_mesh_data_from(mesh_node : MeshInstance3D, cache : ORC_ProxyCache) -> ORC_PotatoGD_MeshData:
	var mesh_data : ORC_PotatoGD_MeshData = create_and_register_primary(ORC_PotatoGD_MeshData, cache)
	mesh_data.model_matrix_bytes = proj_to_bytes(Projection(mesh_node.global_transform))

	for i in range(0, mesh_node.mesh.get_surface_count()):
		var surface_data : ORC_PotatoGD_SurfaceData = create_surface_data_from(mesh_node.mesh, mesh_data, i, cache)
		mesh_data.surfaces_data.append(surface_data)

	return mesh_data

func create_surface_data_from(mesh : Mesh, mesh_data : ORC_PotatoGD_MeshData, surface_index : int, cache : ORC_ProxyCache) -> ORC_PotatoGD_SurfaceData:
	var surface_data : ORC_PotatoGD_SurfaceData = create_and_register_secondary(ORC_PotatoGD_SurfaceData, cache, mesh_data)
	
	surface_data.topology_data = create_topology_data_from(mesh, mesh_data, surface_index, cache)
	
	var material : BaseMaterial3D = mesh.surface_get_material(surface_index)
	surface_data.material_data = create_material_data_from(material, mesh_data, cache)

	return surface_data

func create_topology_data_from(mesh : Mesh, mesh_data : ORC_PotatoGD_MeshData, surface_index : int, cache : ORC_ProxyCache) -> ORC_PotatoGD_TopologyData:
	var unique_id : int = mesh.get_instance_id()
	var topology_data : ORC_PotatoGD_TopologyData = create_and_register_secondary(ORC_PotatoGD_TopologyData, cache, mesh_data, unique_id)
	topology_data.unique_id = unique_id

	var arrays = mesh.surface_get_arrays(surface_index)
	topology_data.index_count = arrays[Mesh.ARRAY_INDEX].size()
	var byte_array = arrays[Mesh.ARRAY_INDEX].to_byte_array()
	topology_data.index_buffer = ORC.rd.index_buffer_create(arrays[Mesh.ARRAY_INDEX].size(), RenderingDevice.INDEX_BUFFER_FORMAT_UINT32, byte_array)
	topology_data.index_array = ORC.rd.index_array_create(topology_data.index_buffer, 0, topology_data.index_count)

	topology_data.vertex_count = arrays[Mesh.ARRAY_VERTEX].size()
	byte_array = arrays[Mesh.ARRAY_VERTEX].to_byte_array()
	topology_data.position_buffer = ORC.rd.vertex_buffer_create(byte_array.size(), byte_array)

	return topology_data

func create_material_data_from(material : BaseMaterial3D, mesh_data : ORC_PotatoGD_MeshData, cache : ORC_ProxyCache) -> ORC_PotatoGD_MaterialData:
	var unique_id : int = material.get_instance_id()
	var material_data : ORC_PotatoGD_MaterialData = create_and_register_secondary(ORC_PotatoGD_MaterialData, cache, mesh_data, unique_id)
	material_data.unique_id = unique_id

	var albedo_floats_array : PackedFloat32Array = [material.albedo_color.r, material.albedo_color.g, material.albedo_color.b, material.albedo_color.a]
	var bytes : PackedByteArray =  albedo_floats_array.to_byte_array()
	material_data.albedo_buffer = ORC.rd.uniform_buffer_create(bytes.size(), bytes)

	return material_data

func free_proxy_override(proxy_object : ORC_ProxyObject) -> bool:
		return true
		
func free_data_override(data : ORC_ProxyData, cache : ORC_ProxyCache) -> bool:
	if data is ORC_PotatoGD_CameraData:
		return free_camera_data(data, cache)
	elif data is ORC_PotatoGD_MeshData:
		return free_mesh_data(data, cache)
	elif data is ORC_PotatoGD_SurfaceData:
		return free_surface_data(data, cache)
	elif data is ORC_PotatoGD_TopologyData:
		return free_topology_data(data, cache)
	elif data is ORC_PotatoGD_MaterialData:
		return free_material_data(data, cache)
	return false
	
func free_camera_data(cam_data : ORC_PotatoGD_CameraData, cache : ORC_ProxyCache) -> bool:
	if cam_data.matrices_uniform_buffer != RID():
		ORC.rd.free_rid(cam_data.matrices_uniform_buffer)
		cam_data.matrices_uniform_buffer = RID()

	return destroy_and_unregister_data(cam_data, cache)
	
func free_mesh_data(mesh_data : ORC_PotatoGD_MeshData, cache : ORC_ProxyCache) -> bool:
	return destroy_and_unregister_data(mesh_data, cache)
	
func free_surface_data(surface_data : ORC_PotatoGD_SurfaceData, cache : ORC_ProxyCache) -> bool:
	return destroy_and_unregister_data(surface_data, cache)
	
func free_topology_data(topology_data : ORC_PotatoGD_TopologyData, cache : ORC_ProxyCache) -> bool:
	if topology_data.index_array != RID():
		ORC.rd.free_rid(topology_data.index_array)
		topology_data.index_array = RID()
	if topology_data.index_buffer != RID():
		ORC.rd.free_rid(topology_data.index_buffer)
		topology_data.index_buffer = RID()
	if topology_data.position_buffer != RID():
		ORC.rd.free_rid(topology_data.position_buffer)
		topology_data.position_buffer = RID()
	
	return destroy_and_unregister_data(topology_data, cache, topology_data.unique_id)
	
func free_material_data(material_data : ORC_PotatoGD_MaterialData, cache : ORC_ProxyCache) -> bool:
	if material_data.albedo_buffer != RID():
		ORC.rd.free_rid(material_data.albedo_buffer)
		material_data.albedo_buffer = RID()
	return destroy_and_unregister_data(material_data, cache)

const SIZEOF_MAT4 = 64 

static func proj_to_bytes(proj : Projection) -> PackedByteArray:
	var byte_array : PackedByteArray = PackedByteArray()
	byte_array.resize(SIZEOF_MAT4)
	
	var offset = 0
	for i in range(4):
		var column = proj[i]
		byte_array.encode_float(offset, column.x)
		offset += 4
		byte_array.encode_float(offset, column.y)
		offset += 4
		byte_array.encode_float(offset, column.z)
		offset += 4
		byte_array.encode_float(offset, column.w)
		offset += 4
	
	return byte_array
