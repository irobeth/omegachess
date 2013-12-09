package net.omegachess.intents
{
	import mx.collections.ArrayCollection;

	public class IntentRegistry extends Object
	{
		internal static var intents : ArrayCollection = new ArrayCollection();
		public function IntentRegistry()
		{
			super();
		}
		
		public static function showIntents() : void {
			for each(var ib : IntentBinding in intents) {
				Debug.show(Debug.INFO, "SHOW INTENTS", ib.toString());
			}
		}
		
		public static function registerIntentHandler( t : String, h : Function, e : Boolean, level : Number = 0 ) : void {
			var ib : IntentBinding = new IntentBinding();
				ib.handler 	= h;
				ib.expunge 	= e;
				ib.level 	= level;
				ib.intent 	= new Intent(null);
				ib.intent.type = t;
				
			intents.addItem(ib);
		}
		
		public static function handleIntent( i : Intent ) : void {
			for each(var ib : IntentBinding in intents) {
				if(ib.intent.type == i.type) {
					ib.handler.call(i.target, i);
					if(ib.expunge) {
						intents.removeItemAt(
							intents.getItemIndex(ib)
						);
					}//if expunge
				}//if type
			}//for
		}//funct
		
		public static function purge( level : Number ) : void {
			var ac : ArrayCollection = new ArrayCollection();
			
			for each(var ib : IntentBinding in intents) {				
				if(ib.level !== level) {
					ac.addItem(ib);									
				}
			}
			
			intents = ac;
		}
	}
}