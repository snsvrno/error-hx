package error;

class Error {
	public static var formats : Map<String,String> = Macros.build();

	public var kind : String;
	public var values : Map<String,Dynamic> = [];

	public function new(details : Dynamic) {
		var keys = Reflect.fields(details);
		for (k in keys) {
			if (k == "kind") kind = Reflect.getProperty(details, k);
			else values.set(k, Reflect.getProperty(details, k));
		}
	}

	public function toString() : String {
		var format = formats.get(kind);

		if (format == null) {
			var msg = 'ERROR kind: $kind';
			for (k => v in values) msg += ', $k: $v';
			return msg;
		} else {
			return render(format, this);
		}
	}

	private static function validVarChar(char : String) : Bool {
		var code = char.charCodeAt(0);
		return (65 <= code && code <= 90) || (97 <= code && code <= 122) || code == 95;
	}

	private static function render(format : String, errorMsg : ErrorMsg) : String {
		var msg = "";
		var pos = 0;
		var char : String;
		var varname = "";
		var isVar = false;
		while ((char = format.charAt(pos++)) != "") {
			if (char == "$") {
				isVar = true;
				varname = "";
			} else if (!validVarChar(char) && isVar) {
				if (varname == "kind") msg += errorMsg.kind;
				else msg += '${errorMsg.values.get(varname)}';
				varname = "";
				isVar = false;
				msg += char;
			} else {
				if (isVar) varname += char;
				else msg += char;
			}
		}
		if (isVar == true && varname.length > 0) {
			if (varname == "kind") msg += errorMsg.kind + " ";
			else msg += '${errorMsg.values.get(varname)} ';
		}
		return msg;
	}

	///////////////////////////////////////////////////////////////

	inline public static function add(values : Dynamic) {
		for (k in Reflect.fields(values))
			msg.values.set(k, Reflect.getProperty(values, k));
	}

	#if result
	inline public static function add<T>(r : result.Result<T,ErrorMsg>, values : Dynamic) {
		switch (r) {
			case Error(msg): msg.add(values);
			case _:
		}
	}
	#end
}
