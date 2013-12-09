package net.omegachess.models
{
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.controllers.movement.IMovementController;
	import net.omegachess.intents.Intent;
	import net.omegachess.intents.IntentRegistry;
	import net.omegachess.moves.movetypes.Move;

	public class GameModel extends Object
	{
		private var _board : Board;
		
		public function GameModel(b : Board) {
			super();
			_board = b;
		}
		
		public function get board() : Board {
			return _board.copy();
		}
		
		public function set board( b : Board) : void {
			_board = b;
			var i : Intent = new Intent(this);
				i.type = Intent.INTENT_TYPE_BOARD_CHANGED;
				i.data = board;
			IntentRegistry.handleIntent(i);
		}
		
		public function applyMove(move : Move) : void {
			_board = move.apply(_board);
			
			var i : Intent = new Intent(this);
				i.type = Intent.INTENT_TYPE_BOARD_CHANGED;
				i.data = board;
			IntentRegistry.handleIntent(i);
		}
	}
}