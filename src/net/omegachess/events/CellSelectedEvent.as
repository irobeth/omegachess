package net.omegachess.events
{
	import flash.events.Event;
	
	import net.omegachess.components.Cell;
	
	public class CellSelectedEvent extends Event
	{
		public static const CELL_SELECTED : String = "cellSelected";
		
		public var cell : Cell;
		
		public function CellSelectedEvent(c : Cell, type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			
			this.cell = c;
		}
	}
}