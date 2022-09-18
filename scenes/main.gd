extends Control


const ErrorPopup = preload("res://components/error_popup.gd")

export var text_edit_path: NodePath
export var topbar_path: NodePath
export var error_popup_path: NodePath

onready var topbar = get_node(topbar_path)
onready var text_edit: TextEdit = get_node(text_edit_path)
onready var error_popup: ErrorPopup = get_node(error_popup_path) as ErrorPopup


func _ready() -> void:
	topbar.run_btn.connect("pressed", self, "_run")
	topbar.clear_btn.connect("pressed", Events, "emit_signal", ["clear_output_requested"])


func _run() -> void:
	Events.emit_signal("clear_output_requested")
	var new_text = text_edit.apply_custom_print_overrides()
	
	var _script: GDScript = GDScript.new()
	_script.source_code = new_text
	
	var err = _script.reload()
	if err:
		error_popup.popup()
		return
	
	Events.emit_signal("run_script_requested", _script)
