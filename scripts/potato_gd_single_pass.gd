extends ORC_RenderPassBase
class_name ORC_PotatoGDSinglePass

func setup_override() -> void:
	super_setup()
	print("ORC_PotatoGDSinglePass.setup()")
	
func render_override() -> void:
	var matrices_uniform : RDUniform = RDUniform.new()
	matrices_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_UNIFORM_BUFFER
	matrices_uniform.binding = 0
	matrices_uniform.add_id(renderer.current_cam_data.matrices_uniform_buffer)
	
	var matrices_uniform_set = ORC.rd.uniform_set_create([matrices_uniform], explicits_pso["Potato_PSO"].shader_program, 0)

	var clear_colors = [Color(0.0, 0.0, 0.0)]
	var draw_flags = RenderingDevice.DRAW_CLEAR_ALL
	var draw_list = ORC.rd.draw_list_begin(framebuffer, draw_flags, clear_colors)
	
	ORC.rd.draw_list_bind_uniform_set(draw_list, matrices_uniform_set, 0)
	ORC.rd.draw_list_bind_render_pipeline(draw_list, explicits_pso["Potato_PSO"].pipeline)

	for surface_data : ORC_PotatoGD_SurfaceData in renderer.surfaces_data:
		var albedo_uniform : RDUniform = RDUniform.new()
		albedo_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_UNIFORM_BUFFER
		albedo_uniform.binding = 0
		albedo_uniform.add_id(surface_data.material_data.albedo_buffer)

		var albedo_uniform_set = ORC.rd.uniform_set_create([albedo_uniform], explicits_pso["Potato_PSO"].shader_program, 1)

		ORC.rd.draw_list_bind_uniform_set(draw_list, albedo_uniform_set, 1)

		ORC.rd.draw_list_bind_vertex_array(draw_list, surface_data.vertex_array)
		ORC.rd.draw_list_bind_index_array(draw_list, surface_data.topology_data.index_array)
		ORC.rd.draw_list_set_push_constant(draw_list, surface_data.mesh_data.model_matrix_bytes, surface_data.mesh_data.model_matrix_bytes.size())
		ORC.rd.draw_list_draw(draw_list, true, 1)

		ORC.rd.free_rid(albedo_uniform_set)

	ORC.rd.draw_list_end()

	ORC.rd.free_rid(matrices_uniform_set)


	
func cleanup_override() -> void:
	super_cleanup()
	print("ORC_PotatoGDSinglePass.cleanup()")
