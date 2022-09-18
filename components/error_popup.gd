extends ColorRect


export var title_label_path: NodePath
export var message_label_path: NodePath
export var ok_btn_path: NodePath

onready var title_label: Label = get_node(title_label_path)
onready var message_label: Label = get_node(message_label_path)
onready var ok_btn: Button = get_node(ok_btn_path)


func _ready() -> void:
	ok_btn.connect("pressed", self, "_dismiss")


func popup() -> void:
	show()
	raise()
	grab_focus()


func _dismiss() -> void:
	hide()
