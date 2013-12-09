package net.omegachess.rules
{
	import net.omegachess.classes.Bitboard;
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Hole;
	import net.omegachess.classes.pieces.King;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.classes.pieces.Rook;
	import net.omegachess.components.Cell;
	
	public class CanCastleKingside implements IOmegaChessRule
	{
		public function CanCastleKingside()
		{
		}
		
		public function satisfies(board:Board) : Boolean {
			Debug.show(Debug.FUNCTION, "CanCastleKingside", "");
			trace(board.toOCPN());
			/*
			1	The king has not previously moved;
			2	The chosen rook has not previously moved;
			3	There must be no pieces between the king and the chosen rook;
			4	The king is not currently in check.
			5	The king must not pass through a square that is under attack by enemy pieces.
			6	The king must not end up in check (true of any legal move).
			7	The king and the chosen rook must be on the same rank.
			*/
			var kingCell : Cell;
			var king : Piece;
			var rook : Piece;
			var rookCell : Cell;
			
			if(board.movingAlignment == Piece.ALIGNMENT_BLACK) {
				kingCell 	= board.blackKing;
				king 		= board.blackKing.piece;				
				//black kingside rook is at I9 (9,9)
				rookCell 	= board.getCellAt(10, 9);
				rook 		= rookCell.piece;
			} else { //we can assume it's white, the exception gets thrown when we retreive movingAlignment if it isn't
				kingCell 	= board.whiteKing;				
				king 		= board.whiteKing.piece;				
				//white kingside rook is at I9 (0,9)
				rookCell 	= board.getCellAt(1, 9);
				rook 		= rookCell.piece;
			}
			
			//need to check what piece type it is, if it's not a rook, then hasMoved should be true.
			//but, if you promote it might not be.
			if(!(rook is Rook)) {
				Debug.show(Debug.INFO, "CanCastleKingside", "Failing to satisfy because the rook cell wasn't a rook.");
				Debug.show(Debug.INFO, "", rookCell.toString());
				return false;	
			}
			if(rook.alignment != board.movingAlignment) {
				Debug.show(Debug.INFO, "CanCastleKingside", "Failing to satisfy because the rook wasn't owned by the same alignment.");
				return false;	
			}
			
			if(king.hasMoved == true) {
				Debug.show(Debug.INFO, "CanCastleKingside", "Failing to satisfy because the rook king had moved.");
				return false;	
			}			
			if(rook.hasMoved == true) {
				Debug.show(Debug.INFO, "CanCastleKingside", "Failing to satisfy because the rook had moved.");
				return false;	
			}
			
			//get a combined threat board for the other alignment.
			var threatbits : Bitboard = board.getAlignmentThreatBitboard(board.enemyAlignment);
			
			//horizontal sweep in the positive direction from king to rook, every piece should be a hole.
			for(var file : Number = kingCell.file + 1; file < rookCell.file; file ++) {
				if(!(board.getCellAt(kingCell.rank, file).piece is Hole)) {
					Debug.show(Debug.INFO, "CanCastleKingside", "Failing to satisfy because " + board.getCellAt(kingCell.rank, file).toACN() + " is occupied by " + board.getCellAt(kingCell.rank, file).piece.acn());
					return false;	
				}
				if(threatbits.getBitAt(kingCell.rank, file) != 0) {
					Debug.show(Debug.INFO, "CanCastleKingside", "Failing to satisfy because " + board.getCellAt(kingCell.rank, file).toACN() + " is threatened.");
					return false;	
				}
			} 
			
						
			return true;
		}
	}
}