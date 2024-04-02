package error.file;

class EFileDoesNotExist implements error.Error {

	public var file:String;

	public function new(path:String) {
		file = path;
	}

	public function toString() : String {
		return c('$file does not exist.');
	}

}
