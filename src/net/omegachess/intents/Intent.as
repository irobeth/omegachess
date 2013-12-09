package net.omegachess.intents
{
	public class Intent extends Object
	{
		public static var INTENT_TYPE_MOVE_DECIDED 	: String = "MOVE_DECIDED_INTENT";
		public static var INTENT_TYPE_BOARD_CHANGED : String = "BOARD_CHANGED_INTENT";
		public static var INTENT_TYPE_CELL_SELECTED : String = "CELL_SELECTED_INTENT";
		public static var INTENT_TYPE_START_TASK	: String = "START_TASK_INTENT";
		public static var INTENT_TYPE_DRAW_MOVES	: String = "DRAW_MOVES_INTENT";
		public static var INTENT_TYPE_PROMOTION		: String = "PROMOTION_INTENT";
		public static var INTENT_TYPE_SAVE_MOVE		: String = "INTENT_SAVE_MOVE";
		
		public var type : String;
		public var data : Object;
		public var target : Object;
		
		public function Intent(target : Object)
		{
			super();
			
			this.target = target;
		}
	}
}