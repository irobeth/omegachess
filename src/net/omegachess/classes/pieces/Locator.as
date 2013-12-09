package net.omegachess.classes.pieces
{
	public class Locator
	{
		public static function GetPieceFromOCPN(char : String, rank : Number, file : Number) {
			//WWww/crnbqkbnrc/pppppppppp/A/A/A/A/A/A/PPPPPPPPPP/CRNBQKBNRC w KQkq KQkq - wb -- 0 1
			
			var map : Object = {
				"W": Wizard,
				"C": Champion,
				"R": Rook,
				"N": Knight,
				"B": Bishop,
				"Q": Queen,
				"K": King,
				"P": Pawn,
				"1": Hole
			};
									
			var pieceClass : Class = map[char.toUpperCase()];

			var piece : Piece = new pieceClass();
			
			if(char === char.toUpperCase()) {
				piece.alignment = Piece.ALIGNMENT_WHITE;
			} else {
				piece.alignment = Piece.ALIGNMENT_BLACK;
			}
			
			
			return piece;
		}
	}
}