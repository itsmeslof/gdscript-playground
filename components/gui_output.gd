extends Control


export var info_label_path: NodePath
export var output_wrapper_path: NodePath

onready var info_label: Label = get_node(info_label_path)
onready var output_wrapper: Control = get_node(output_wrapper_path)


func render(control: Control) -> void:
	_remove_children()
	info_label.hide()
	output_wrapper.add_child(control)


func reset() -> void:
	_remove_children()
	info_label.show()


func _remove_children() -> void:
	for child in output_wrapper.get_children():
		output_wrapper.remove_child(child)
		child.queue_free()
