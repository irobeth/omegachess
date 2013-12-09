package net.omegachess.tasks
{
	import flash.events.Event;
	
	public class TaskEvent extends Event
	{
		public static const BLOCK : String = "TaskEvent:Block";
		public static const SLEEP : String = "TaskEvent:Sleep";
		public static const KILL : String = "TaskEvent:Kill";
		public static const KILLED : String = "TaskEvent:Killed";
		public static const COMPLETE : String = "TaskEvent:Complete";
		public static const ERROR : String = "TaskEvent:Error";
		
		public var error : Error;
		public var data : Object;
		public var task : Task;
		
		public function TaskEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}