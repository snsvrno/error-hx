package error.file;

class EFileIsDir implements error.Error {

	public var file:String;

	public function new(path:String) {
		file = path;
	}

	public function toString() : String {
		return c('$file is a directory but expected to be a file.');
	}
}
