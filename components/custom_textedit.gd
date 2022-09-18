extends TextEdit


#const CONTROL_FLOW = [
#	"if",
#	"else",
#	"elif",
#	"match",
#	"continue",
#	"break",
#	"for",
#	"while",
#	"return",
#	"pass"
#]
#
#const BASE = [
#	"null",
#	"String",
#	"Vector"
#]
#
#const KEYWORDS = [
#	""
#]


const CONTROL_FLOW := [
	'if',
	'else',
	'elif',
	'match',
	'pass',
	'for',
	'while',
	'pass',
	'break',
	'continue',
	'return',
	'yield',
	'func',
	'or',
	'as',
	'is',
	'in',
	'assert'
]

const BUILT_IN := [
	'bool',
	'int',
	'float',
	'String',
	'Vector2',
	'Vector3',
	'NodePath',
	'Object',
	'Array',
	'PoolByteArray',
	'PoolIntArray',
	'PoolRealArray',
	'PoolStringArray',
	'PoolVector2Array',
	'PoolVector3Array',
	'PoolColorArray',
	'Dictionary',
	'INF',
	'NAN',
	'PI',
	'TAU',
	'null',
	'void',
]

const KEYWORDS = [
	'var',
	'const',
	'enum',
	'void',
	'static',
	'export',
	'extends',
	'onready',
	'signal',
	'class_name',
	'class',
	'tool',
	'setget',
	'remote',
	'master',
	'puppet',
	'remotesync',
	'puppetsync',
	'sync',
	'breakpoint',
	'self',
	'true',
	'false',
#	'func'
]


const CUSTOM_PRINT_FUNCS = {
	"print": "__print__",
	"prints": "__prints__",
	"printt": "__printt__",
	"printraw": "__printraw__"
}

const SEPARATORS = {
	"print": "",
	"prints": " ",
	"printt": "\\t",
	"printraw": ""
}

var script_injection = ""

var print_func_template = """
func {custom_func}(arg1 = '', arg2 = '', arg3 = '', arg4 = '', arg5 = '', arg6 = '', arg7 = '', arg8 = '', arg9 = '') -> void:
#	Preserve original function call
	{original_func}(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	
	var output_text: String = ''
	for arg in [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9]:
		# We check if it's an empty string so we don't append extra separators to the end
		if not arg:
			continue
		
		if output_text.empty():
			output_text += str(arg)
		else:
			output_text += '{separator}' + str(arg)
	
	output_text += '{end_separator}'
	
	Events.emit_signal('custom_print_func_called', output_text)
"""


func _ready() -> void:
	add_color_region("\"", "\"", Color("#9ECBFF"), false)
	add_color_region("'", "'", Color("#9ECBFF"), false)
	add_color_region("#", "", Color("#60666B"), true)
	
	for kw in KEYWORDS:
		add_keyword_color(kw, Color("#E86D63"))
	
	for kw in CONTROL_FLOW:
		add_keyword_color(kw, Color("#E86D63"))
	
	for _class in ClassDB.get_class_list():
		add_keyword_color(_class, Color("#B392F0"))
	
	for kw in BUILT_IN:
		add_keyword_color(kw, Color("#B392F0"))
	
	for print_func in CUSTOM_PRINT_FUNCS:
		var custom_func = CUSTOM_PRINT_FUNCS[print_func]
		script_injection += print_func_template.format({
			"custom_func": custom_func,
			"original_func": print_func,
			"separator": SEPARATORS[print_func],
			"end_separator": "" if print_func == "printraw" else "\\n"
		})


func apply_custom_print_overrides() -> String:
	var new_text = self.text
	
	for print_func in CUSTOM_PRINT_FUNCS:
		new_text = new_text.replace(
			"{original_func}(".format({
				original_func = print_func
			}),
			"{new_func}(".format({
				new_func = CUSTOM_PRINT_FUNCS[print_func]
			})
		)
	
	new_text += "\n{script_injection}".format({
		script_injection = self.script_injection
	})
	return new_text
