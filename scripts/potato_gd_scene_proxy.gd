extends ORC_SceneProxyBase
class_name ORC_PotatoGDSceneProxy

func setup_override(node : Node) -> void:
	super_setup(node)
	print("ORC_PotatoGDSceneProxy.setup ", node.name)
	
func pre_render_override() -> void:
	super_pre_render()
	print("ORC_PotatoGDSceneProxy.pre_render")
	
func post_render_override() -> void:
	super_post_render()
	print("ORC_PotatoGDSceneProxy.post_render")
	
func cleanup_override() -> void:
	super_cleanup()
	print("ORC_PotatoGDSceneProxy.cleanup")
