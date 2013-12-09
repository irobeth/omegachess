package net.omegachess.events
{
	import flash.events.Event;
	
	public class PieceSelectedEvent extends Event
	{
		public static var PIECE_SELECTED : String = "PSE#PIECE_SELECTED";
		
		
		
		public function PieceSelectedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}