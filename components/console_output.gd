extends Control

export var info_label_path: NodePath
export var output_buffer_path: NodePath

onready var info_label: Label = get_node(info_label_path)
onready var output_buffer: TextEdit = get_node(output_buffer_path)


func _ready() -> void:
	Events.connect("custom_print_func_called", self, "_handle_custom_print_func")
	Events.connect("clear_output_requested", self, "reset")


func _handle_custom_print_func(text: String) -> void:
	info_label.hide()
	output_buffer.show()
	output_buffer.text += text


func reset() -> void:
	output_buffer.text = ""
	output_buffer.hide()
	info_label.show()
