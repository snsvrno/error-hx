package error;

private enum Section {
	Text(text : String);
	Var(name : String);
	Func(fname : String, vname : String);
}

class Format {
	private final template : String;
	private var cursor : Int = 0;

	/////

	private function new(template : String) {
		this.template = template;
	}

	/////

	private function next() : Null<Section> {
		var text = "";
		var char;
		while ((char = template.charAt(cursor++)) != "") {
			if (char == "$") {
				if (text.length == 0) {
					// we are new here, so lets process this

					if (template.charAt(cursor) == "{") {
						cursor++;
						// this is complex, there is some kind of 
						// processing function call
						var fname = "";
						while ((char = template.charAt(cursor++)) != "(")
							fname += char;

						while (validVarChar(char = template.charAt(cursor++)))
							text += char;

						if (char != ")") throw "error1";
						if ((char = template.charAt(cursor++)) != "}") throw "error2";

						return Func(fname, text);

					} else {
						// this is simple, just a var name
						while (validVarChar(char = template.charAt(cursor++)))
							text += char;

						cursor -= 1;
						return Var(text);

					}
				} else {
					// we found the marker but we already had some
					// text, so lets stop and save that for next time
					cursor -= 1;
					return Text(text);
				}

			} else {
				// nothing, so we add
				text += char;
			}
		}

		// catching the last part at the end of the string
		if (text.length > 0) return Text(text);
		else return null;
	}

	/////

	public static function format(template : String, error : Error) : String {
		var formatter = new Format(template);
		var section;
		var msg : String = "";

		while ((section = formatter.next()) != null) {
			switch (section) {
				case Text(text): 
					msg += text;

				case Var(name):
					if (name == "kind") msg += error.kind;
					else msg += '${error.values.get(name)}';

				case Func(fname, vname):
					var func = Error.functions.get(fname);
					if (func == null) throw 'no error_format function $fname found';

					var value = if (vname == "kind") error.kind;
					else '${error.values.get(vname)}';

					msg += func(value);
			}
		}

		return msg;
	}

	////////

	private static function validVarChar(char : String) : Bool {
		var code = char.charCodeAt(0);
		return (65 <= code && code <= 90) || (97 <= code && code <= 122) || code == 95;
	}

}
