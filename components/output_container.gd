extends PanelContainer


const OutputTabs = preload("res://components/output_tabs.gd")


export var output_tabs_path: NodePath
export var gui_output_path: NodePath
export var console_output_path: NodePath

onready var output_tabs: OutputTabs = get_node(output_tabs_path)
onready var gui_output: Control = get_node(gui_output_path)
onready var console_output: Control = get_node(console_output_path)


func _ready() -> void:
	output_tabs.connect("tab_changed", self, "render")
	Events.connect("run_script_requested", self, "_run")
	Events.connect("clear_output_requested", self, "_clear_output")
	
	render(output_tabs.active_tab)


func render(tab: int) -> void:
	gui_output.visible = (tab == output_tabs.AvailableTabs.GUI_OUTPUT)
	console_output.visible = (tab == output_tabs.AvailableTabs.CONSOLE)


func _run(script: GDScript) -> void:
	var _instance = script.new()
	_clear_output()

	if _instance is Control:
		gui_output.render(_instance)
		output_tabs.set_active_tab(output_tabs.AvailableTabs.GUI_OUTPUT)
		return
	
	# No GUI, switch to console
	output_tabs.set_active_tab(output_tabs.AvailableTabs.CONSOLE)


func _clear_output() -> void:
	gui_output.reset()
