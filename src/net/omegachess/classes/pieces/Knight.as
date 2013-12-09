package net.omegachess.classes.pieces
{
	import flash.display.DisplayObject;
	
	import mx.controls.Image;
	
	import net.omegachess.classes.Bitboard;

	[RemoteClass]
	public class Knight extends Piece
	{
		[Embed(source="../assets/Chess_ndt45.png")]
		public static var IMAGE_BLACK : Class;
		[Embed(source="../assets/Chess_nlt45.png")]
		public static var IMAGE_WHITE : Class;		
		
		public function Knight()
		{
			super();
			classification = CLASSIFICATION_LEAPER;
		}
		
		public override function get pointValue() : Number {
			return 3;
		}
				
		public override function getMovementBitboard(boardPieces:Bitboard) : Bitboard {
			var bitboard : Bitboard = new Bitboard();
			
			bitboard.silentSetBitAt((Piece.captureTest(rank + 1, file + 2, boardPieces, alignment) > 0) ? 1 : 0, rank + 1, file + 2);
			bitboard.silentSetBitAt((Piece.captureTest(rank - 1, file + 2, boardPieces, alignment) > 0) ? 1 : 0, rank - 1, file + 2);
			
			bitboard.silentSetBitAt((Piece.captureTest(rank + 1, file - 2, boardPieces, alignment) > 0) ? 1 : 0, rank + 1, file - 2);
			bitboard.silentSetBitAt((Piece.captureTest(rank - 1, file - 2, boardPieces, alignment) > 0) ? 1 : 0, rank - 1, file - 2);
			
			bitboard.silentSetBitAt((Piece.captureTest(rank + 2, file + 1, boardPieces, alignment) > 0) ? 1 : 0, rank + 2, file + 1);
			bitboard.silentSetBitAt((Piece.captureTest(rank - 2, file + 1, boardPieces, alignment) > 0) ? 1 : 0, rank - 2, file + 1);
			
			bitboard.silentSetBitAt((Piece.captureTest(rank + 2, file - 1, boardPieces, alignment) > 0) ? 1 : 0, rank + 2, file - 1);
			bitboard.silentSetBitAt((Piece.captureTest(rank - 2, file - 1, boardPieces, alignment) > 0) ? 1 : 0, rank - 2, file - 1);

			//templar movements
			bitboard.silentSetBitAt((Piece.captureTest(rank + 2, file + 3, boardPieces, alignment) > 0) ? 1 : 0, rank + 2, file + 3);
			bitboard.silentSetBitAt((Piece.captureTest(rank - 2, file + 3, boardPieces, alignment) > 0) ? 1 : 0, rank - 2, file + 3);
			
			bitboard.silentSetBitAt((Piece.captureTest(rank + 2, file - 3, boardPieces, alignment) > 0) ? 1 : 0, rank + 2, file - 3);
			bitboard.silentSetBitAt((Piece.captureTest(rank - 2, file - 3, boardPieces, alignment) > 0) ? 1 : 0, rank - 2, file - 3);
			
			bitboard.silentSetBitAt((Piece.captureTest(rank + 3, file + 2, boardPieces, alignment) > 0) ? 1 : 0, rank + 3, file + 2);
			bitboard.silentSetBitAt((Piece.captureTest(rank - 3, file + 2, boardPieces, alignment) > 0) ? 1 : 0, rank - 3, file + 2);
			
			bitboard.silentSetBitAt((Piece.captureTest(rank + 3, file - 2, boardPieces, alignment) > 0) ? 1 : 0, rank + 3, file - 2);
			bitboard.silentSetBitAt((Piece.captureTest(rank - 3, file - 2, boardPieces, alignment) > 0) ? 1 : 0, rank - 3, file - 2);			
			
			return bitboard;
		}
		
		public override function getCaptureBitboard(boardPieces:Bitboard) : Bitboard {
			var bitboard : Bitboard = new Bitboard();
			
			bitboard.silentSetBitAt((Piece.captureTest(rank + 1, file + 2, boardPieces, alignment) > 0) ? 1 : 0, rank + 1, file + 2);
			bitboard.silentSetBitAt((Piece.captureTest(rank - 1, file + 2, boardPieces, alignment) > 0) ? 1 : 0, rank - 1, file + 2);
			
			bitboard.silentSetBitAt((Piece.captureTest(rank + 1, file - 2, boardPieces, alignment) > 0) ? 1 : 0, rank + 1, file - 2);
			bitboard.silentSetBitAt((Piece.captureTest(rank - 1, file - 2, boardPieces, alignment) > 0) ? 1 : 0, rank - 1, file - 2);
			
			bitboard.silentSetBitAt((Piece.captureTest(rank + 2, file + 1, boardPieces, alignment) > 0) ? 1 : 0, rank + 2, file + 1);
			bitboard.silentSetBitAt((Piece.captureTest(rank - 2, file + 1, boardPieces, alignment) > 0) ? 1 : 0, rank - 2, file + 1);
			
			bitboard.silentSetBitAt((Piece.captureTest(rank + 2, file - 1, boardPieces, alignment) > 0) ? 1 : 0, rank + 2, file - 1);
			bitboard.silentSetBitAt((Piece.captureTest(rank - 2, file - 1, boardPieces, alignment) > 0) ? 1 : 0, rank - 2, file - 1);
			
			return bitboard;
		}
		
		public override function getItemRenderer() : DisplayObject {
			
			var i : Image = new Image();
			i.width = 48;
			i.height = 48;
			
			switch(this.alignment) {
				case Piece.ALIGNMENT_WHITE :
					i.source = IMAGE_WHITE;
					break;
				case Piece.ALIGNMENT_BLACK :
					i.source = IMAGE_BLACK;
					break;				
			}
			
			return i;
			
		}
		
		public override function acn() : String {
			return alignment == Piece.ALIGNMENT_WHITE ? "N" : "n";
		}
	}
}