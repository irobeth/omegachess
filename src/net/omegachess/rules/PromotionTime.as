package net.omegachess.rules
{
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Pawn;
	import net.omegachess.classes.pieces.Piece;
	
	public class PromotionTime implements IOmegaChessRule
	{
		public function PromotionTime()
		{
		}
		
		public function satisfies(board:Board):Boolean
		{
			//assuming we made a move so the alignments are swapped already
			var promotingAlignment : Number = board.enemyAlignment;
			var rank : Number;
			if(promotingAlignment == Piece.ALIGNMENT_WHITE) {
				rank = 10;
			} else {
				rank = 1;
			}
			
			//sweep across the rank and look for pawns; since pawns can't move backward, we don't need to check alignment.
			for(var f : Number = 0; f < 11; f++) {
				if(board.getCellAt(rank, f).piece is Pawn) {
					return true;
				}
			}
			
			return false;
		}
	}
}