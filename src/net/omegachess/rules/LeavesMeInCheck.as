package net.omegachess.rules
{
	import net.omegachess.classes.Bitboard;
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.components.Cell;

	public class LeavesMeInCheck implements IOmegaChessRule {
		
		public function LeavesMeInCheck() {
			
		}
		
		/**
		 * applying a move changes whoCanMove so 'leaves me in check'
		 * is more like 'leaves the new enemy in check' blah
		 * */
		public function satisfies( board : Board ) : Boolean {
						
			var alignment : Number = board.enemyAlignment;
			
			var king : Cell;
			
			if(alignment == Piece.ALIGNMENT_WHITE) {
				king = board.whiteKing;
			} else {
				king = board.blackKing;
			}
							
			//produce the enemy alignment
			var enemyAlignment : Number = board.movingAlignment;
			
			//is our king threatened?
			var threatBoard : Bitboard = board.getAlignmentThreatBitboard(enemyAlignment);
			
			//if so, it's check
			return threatBoard.getBitAt(king.rank, king.file) != 0;
			
		}//satisfies		
		
	}//class
	
}//package