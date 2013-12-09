package net.omegachess.intents
{
	internal class IntentBinding extends Object
	{
		internal var intent : Intent;
		internal var handler : Function;
		internal var expunge : Boolean;
		internal var level : Number;
		
		public function IntentBinding()
		{
			super();
		}
		
		public function toString() : String {
			return level.toString() + (expunge ? "!" : "") + " - " + intent.type;
		}
	}
}