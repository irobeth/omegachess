package
{
	import flash.events.Event;
	
	import mx.utils.ObjectUtil;
	
	public class Debug extends Object
	{
		
		//1b
		public static const INFO : uint = 1;
		//10b
		public static const DEBUG : uint = 2;
		//100b
		public static const DUMP : uint = 4;
		//1000b
		public static const ERROR : uint = 8;
		//10000b
		public static const TRACE : uint = 16;
		//100000b
		public static const VERBOSE_1 : uint = 32;
		//1000000b
		public static const VERBOSE_2 : uint = 64;
		//10000000b
		public static const VERBOSE_3 : uint = 128;
		//100000000b
		public static const FUNCTION : uint = 256;		
		//111111111b
		//public static var debugLevel : uint = 511 ^ VERBOSE_3 ^ VERBOSE_2 ^ INFO ^ VERBOSE_1 ^ FUNCTION ^ DUMP;
		public static var debugLevel : uint = 511 ^ VERBOSE_3;
		
		
		public function Debug()
		{
			super();
		}
		
		public static function show( level : uint, location : String, info : Object = null ) : void {
			
			if((level & debugLevel) > 0) {
				
				var output : String = "";
				output = 	"[" + Debug.getLevelString(level) + "] " + 
								location;
								
				output = Debug.pad(output);				
				
				
				if(level == Debug.DUMP) {
					
					output = Debug.pad("[" + Debug.getLevelString(level) + "]") + ": "+ location;					
					trace(output);
					
					output = ObjectUtil.toString(info);
					trace(output);
					
					output = Debug.pad("[/" + location + "]");
					
				} else if(level == Debug.FUNCTION) {
					
					output = Debug.pad("[" + Debug.getLevelString(level) + "]") + ": Function " + location;
					if(info != null) {
						output += "(" + info + ")"
					}
					
				} else if(level == Debug.TRACE) { // TRACE functions like this; 
					output = 	output + ": " + 
								(info.toString());
				} else {
					output = 	output + ": " + 
						(info.toString());
				}
										
				trace(output);
				
			}
		}
		
		private static function getLevelString(level : uint) : String {
			switch(level) {
				
				case Debug.INFO :
					return "INFO";
				case Debug.DEBUG :
					return "DEBUG";
				case Debug.DUMP :
					return "DUMP"; 
				case Debug.ERROR :
					return "ERROR";
				case Debug.TRACE :					
				case Debug.VERBOSE_1 :					
				case Debug.VERBOSE_2 :					
				case Debug.VERBOSE_3 :
					return "TRACE";
				case Debug.FUNCTION :
					return "FUNCTION";
				default : 
					return "UNKNOWN";
				break;		
			}
		}
		
		private static function pad( str : String ) : String {
			while(str.length <= 50) {
					str = str + " ";
			}
			
			return str;
		}
	}
}