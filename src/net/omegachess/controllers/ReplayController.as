package net.omegachess.controllers
{
	import mx.collections.ArrayCollection;
	
	import net.omegachess.classes.Board;
	import net.omegachess.intents.Intent;
	import net.omegachess.intents.IntentRegistry;
	import net.omegachess.moves.movetypes.Move;

	public class ReplayController extends Object
	{		
		private var _moves : ArrayCollection = new ArrayCollection();
		
		public function ReplayController() {
			super();
			
			IntentRegistry.registerIntentHandler(Intent.INTENT_TYPE_SAVE_MOVE, logMove, false, 9);
		}
		
		private function logMove( intent : Intent ) : void {
			var move : Move = intent.data as Move;
			_moves.addItem(move);
		}
		
		//replays the game up to the move at 'index'
		private function replay(index : Number) : void {
			var board : Board = new Board();
			var populator : DefaultBoardPopulator = new DefaultBoardPopulator();
				populator.populate(board);
						
			for(var i : Number = 0; i <= index; i++) {
				board = (_moves.getItemAt(i) as Move).apply(board);
			}
			
			
		}
	}
}