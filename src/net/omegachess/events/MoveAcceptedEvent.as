package net.omegachess.events
{
	import flash.events.Event;
	
	import net.omegachess.classes.Board;
	
	public class MoveAcceptedEvent extends Event
	{
		public static const ACCEPTED : String = "MOVE_ACCEPTED";
		
		public var position : Board;
		
		public function MoveAcceptedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}