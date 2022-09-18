extends PanelContainer


export var clear_btn_path: NodePath
export var run_btn_path: NodePath

onready var clear_btn: Button = get_node(clear_btn_path)
onready var run_btn: Button = get_node(run_btn_path)
