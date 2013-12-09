package net.omegachess.rules
{
	import net.omegachess.classes.Bitboard;
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.components.Cell;

	public class Check implements IOmegaChessRule {
		
		public function Check() {
			
		}
		
		public function satisfies( board : Board ) : Boolean {
			
			//get whose move it currently is
			var alignment : Number = board.movingAlignment;
			
			var king : Cell;
			
			if(alignment == Piece.ALIGNMENT_WHITE) {
				king = board.whiteKing;
			} else {
				king = board.blackKing;
			}
							
			//produce the enemy alignment
			var enemyAlignment : Number = board.enemyAlignment;
			
			//is our king threatened?
			var threatBoard : Bitboard = board.getAlignmentThreatBitboard(enemyAlignment);
			
			//if so, it's check
			return threatBoard.getBitAt(king.rank, king.file) != 0;
			
		}//satisfies		
		
	}//class
	
}//package