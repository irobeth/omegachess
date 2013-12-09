package net.omegachess.rules
{
	import flash.utils.getTimer;
	
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.components.Cell;
	import net.omegachess.moves.MoveFactory;
	import net.omegachess.moves.movetypes.Move;
	
	public class Checkmate implements IOmegaChessRule
	{
		public function Checkmate()
		{
		}
		
		public function satisfies(board:Board):Boolean
		{
			/**
			 * Time for gross.
			 * There's a easy, slow way to do this
			 * There's a more difficult, faster way to do this.
			 * 
			 * For now, the slow and easy route
			 * */
			
			//get whose move it currently is
			var alignment : Number 					= board.movingAlignment;			
			var check : Check 						= new Check();

			//we should only look for checkmate if it's currently check.
			new Assertion(check.satisfies(board));
			
			var king : Cell;
			
			if(alignment == Piece.ALIGNMENT_WHITE) {
				king = board.whiteKing;
			} else {
				king = board.blackKing;
			}
			
			//easy, slow
			//take every piece we own, test every move. If we find one such that it isn't check, it's not checkmate.
			
			//typically the king can move out of check, so let's look at the king's moves first
			//this should speed up the average checkmate scan a bunch
			if(cellCanEscapeCheck(king, board)) return false;
			
			Debug.show(Debug.INFO, "Checkmate", "Beginning exhaustive search at " + getTimer());
			//otherwise, long and exhaustive search - go!
			for each(var cell : Cell in board.getCellsFromBitboard(board.getAlignmentBitboard(alignment))) {
				if(cellCanEscapeCheck(cell, board)) return false;
				Debug.show(Debug.INFO, "Checkmate", "Continuing exhaustive search at " + getTimer());
			}
			Debug.show(Debug.INFO, "Checkmate", "Ending exhaustive search at " + getTimer());
			
			return true;
			//hard, faster
			/**
			 * Axioms
			 * 
			 * A king threatened by two riders must move, no other piece can relieve you from check in this situation.
			 * A king threatened by a leaper must either move or the leaper must be captured.
			 * A king threatened by only one rider must either move, or some other piece must move into a square threatened or occupied by the rider.
			 * */
			return false;
		}
		
		private function cellCanEscapeCheck(cell : Cell, board : Board) : Boolean {
			var leavesMeInCheck : LeavesMeInCheck 	= new LeavesMeInCheck();
			
			var testBoard : Board;
			
			for each(var m : Move in MoveFactory.getMoves(cell, board)) {
				testBoard = m.apply(board);
				if(!leavesMeInCheck.satisfies(testBoard)) return true;
				Debug.show(Debug.INFO, "canEscape", m.toACN() + " fails to escape check.");
			}				
			
			return false;
		}
	}
}