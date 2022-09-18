extends PanelContainer


signal tab_changed(new_tab)


export var gui_output_tab_path: NodePath
export var console_tab_path: NodePath

onready var gui_output_tab_btn: Button = get_node(gui_output_tab_path)
onready var console_tab_btn: Button = get_node(console_tab_path)

enum AvailableTabs {
	GUI_OUTPUT,
	CONSOLE
}

var active_tab: int


func _ready() -> void:
	connect_signals()
	set_active_tab(AvailableTabs.GUI_OUTPUT)
	render()

func connect_signals() -> void:
	gui_output_tab_btn.connect("pressed", self, "set_active_tab", [AvailableTabs.GUI_OUTPUT])
	console_tab_btn.connect("pressed", self, "set_active_tab", [AvailableTabs.CONSOLE])

func render() -> void:
	gui_output_tab_btn.disabled = (active_tab == AvailableTabs.GUI_OUTPUT)
	console_tab_btn.disabled = (active_tab == AvailableTabs.CONSOLE)

func set_active_tab(tab: int) -> void:
	if not tab in [AvailableTabs.GUI_OUTPUT, AvailableTabs.CONSOLE]:
		printerr("Invalid tab")
		set_active_tab(AvailableTabs.GUI_OUTPUT)
		return
	
	active_tab = tab
	emit_signal("tab_changed", tab)
	
	render()
