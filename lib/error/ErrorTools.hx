package error;

class ErrorTools {

	inline public static function add(e : Error, values : Dynamic) {
		for (k in Reflect.fields(values))
			msg.values.set(k, Reflect.getProperty(values, k));
	}
}
