package error;

interface Error {
	public function toString() : String;
}

inline macro function passthrough(item:haxe.macro.Expr) {
	return item;
}
