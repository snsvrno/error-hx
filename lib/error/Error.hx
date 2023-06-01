package error;

class Error {
	public static var formats : Map<String,String> = Macros.buildMessageTemplates();
	public static var functions : Map<String, (s:String) -> String> = [
	#if ansi
		"red" => (s:String) -> ansi.Paint.paint(s, Red),
		"green" => (s:String) -> ansi.Paint.paint(s, Green),
		"yellow" => (s:String) -> ansi.Paint.paint(s, Yellow),
		"blue" => (s:String) -> ansi.Paint.paint(s, Blue),
		"magenta" => (s:String) -> ansi.Paint.paint(s, Magenta),
		"cyan" => (s:String) -> ansi.Paint.paint(s, Cyan),
	#end
	];


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
			return Format.format(format, this);
		}
	}

}
