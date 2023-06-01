package error;

class Macros {
	public static var COMPILER_DEFINE = "error_format_";

	public static macro function buildMessageTemplates() : haxe.macro.Expr {
		var map : Map<String, String> = new Map();

		var d = haxe.macro.Context.getDefines();
		for (k => v in d) {
			if (k.substring(0,COMPILER_DEFINE.length) == COMPILER_DEFINE) {
				var kind = k.substring(COMPILER_DEFINE.length).split("_").join(" ");
				map.set(kind,v);
			}
		}

		return macro $v{map};
	}
}
