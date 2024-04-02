package error;

class EGeneric implements Error {
	public var msg:String;

	public function new(msg:String) {
		this.msg = msg;
	}

	public function toString() : String {
		return c('$msg');
	}

}
