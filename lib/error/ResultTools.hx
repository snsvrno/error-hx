package error;

using error.ErrorTools;

class ResultTools {

	#if result
	inline public static function add<T>(result : result.Result<T,Error>, values : Dynamic) {
		switch (result) {
			case Error(msg): msg.add(values);
			case _:
		}
	}
	#end
}
