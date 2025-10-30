extends ORC_RendererBase
class_name ORC_PotatoGDRenderer

var current_cam_data : ORC_PotatoGD_CameraData
var surfaces_data : Array[ORC_PotatoGD_SurfaceData]

func setup_override() -> void:
	pass

func pre_render_override() -> void:
	super_pre_render()
	var cameras_data : Array = scene_proxy.get_by_type(ORC_PotatoGD_CameraData)
	for camera_data : ORC_PotatoGD_CameraData in cameras_data:
		if camera_data.proxy_object.node.current:
			current_cam_data = camera_data
			break
	
	var non_casted_surfaces_data : Array = scene_proxy.get_by_type(ORC_PotatoGD_SurfaceData)
	surfaces_data.clear()
	for surface_data : ORC_PotatoGD_SurfaceData in non_casted_surfaces_data:
		surfaces_data.append(surface_data)
	
func render_override() -> void:
	(render_passes["Single"] as ORC_PotatoGDSinglePass).render()

func get_render_target_override() -> RID:
	return attachments["Albedo"];

func cleanup_override() -> void:
	pass
