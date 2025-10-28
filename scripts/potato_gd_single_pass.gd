extends ORC_RenderPassBase
class_name ORC_PotatoGDSinglePass

func setup_override() -> void:
	super_setup()
	print("ORC_PotatoGDSinglePass.setup()")
	
func render_override() -> void:
	super_render()
	print("ORC_PotatoGDSinglePass.render()")
	
func cleanup_override() -> void:
	super_cleanup()
	print("ORC_PotatoGDSinglePass.cleanup()")
