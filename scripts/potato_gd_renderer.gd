extends ORC_RendererBase
class_name ORC_PotatoGDRenderer

func setup_override() -> void:
	super_setup()
	print("ORC_PotatoGDRenderer.setup")

func pre_render_override() -> void:
	super_pre_render()
	print("ORC_PotatoGDRenderer.pre_render")
	
func render_override() -> void:
	super_render()
	print("ORC_PotatoGDRenderer.render")

func get_render_target_override() -> RID:
	return super_get_render_target();
	
func cleanup_override() -> void:
	super_cleanup()
	print("ORC_PotatoGDRenderer.cleanup")
