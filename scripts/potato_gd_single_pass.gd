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
	
	print((renderer as ORC_PotatoGDRenderer).current_cam_data.proxy_object.node.name)
	for surf_data : ORC_PotatoGD_SurfaceData in (renderer as ORC_PotatoGDRenderer).surfaces_data:
		print(surf_data.primary_data_array[0].proxy_object.node.name)
	
func cleanup_override() -> void:
	super_cleanup()
	print("ORC_PotatoGDSinglePass.cleanup()")
