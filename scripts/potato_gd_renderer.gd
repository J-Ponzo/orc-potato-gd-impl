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

func proc_0_args_override() -> void:
	super_proc_0_args()
	print("ORC_PotatoGDRenderer.proc_0_args")
	
func proc_1_args_override(arg1 : int) -> void:
	super_proc_1_args(arg1)
	print("ORC_PotatoGDRenderer.proc_1_args ", arg1)
	
func proc_2_args_override(arg1 : int, arg2 : int) -> void:
	super_proc_2_args(arg1, arg2)
	print("ORC_PotatoGDRenderer.proc_2_args ", arg1, " ", arg2)
	
func proc_3_args_override(arg1 : int, arg2 : int, arg3 : int) -> void:
	super_proc_3_args(arg1, arg2, arg3)
	print("ORC_PotatoGDRenderer.proc_3_args ", arg1, " ", arg2, " ", arg3)
	
func proc_4_args_override(arg1 : int, arg2 : int, arg3 : int, arg4 : int) -> void:
	super_proc_4_args(arg1, arg2, arg3, arg4)
	print("ORC_PotatoGDRenderer.proc_4_args ", arg1, " ", arg2, " ", arg3, " ", arg4)

func func_0_args_override() -> int:
	var result : int = super_func_0_args()
	print(result, " ORC_PotatoGDRenderer.func_0_args")
	return result
	
func func_1_args_override(arg1 : int) -> int:
	var result : int = super_func_1_args(arg1)
	print(result, " ORC_PotatoGDRenderer.func_1_args ", arg1)
	return result
	
func func_2_args_override(arg1 : int, arg2 : int) -> int:
	var result : int = super_func_2_args(arg1, arg2)
	print(result, " ORC_PotatoGDRenderer.func_2_args ", arg1, " ", arg2)
	return result
	
func func_3_args_override(arg1 : int, arg2 : int, arg3 : int) -> int:
	var result : int = super_func_3_args(arg1, arg2, arg3)
	print(result, " ORC_PotatoGDRenderer.func_3_args ", arg1, " ", arg2, " ", arg3)
	return result
	
func func_4_args_override(arg1 : int, arg2 : int, arg3 : int, arg4 : int) -> int:
	var result : int = super_func_4_args(arg1, arg2, arg3, arg4)
	print(result, " ORC_PotatoGDRenderer.func_4_args ", arg1, " ", arg2, " ", arg3, " ", arg4)
	return result
