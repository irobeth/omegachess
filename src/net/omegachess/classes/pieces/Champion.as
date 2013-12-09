package net.omegachess.classes.pieces
{
	import flash.display.DisplayObject;
	
	import mx.controls.Image;
	
	import net.omegachess.classes.Bitboard;
	
	[RemoteClass]
	public class Champion extends Piece
	{
		[Embed(source="../assets/Chess_zdt45.png")]
		public static var IMAGE_BLACK : Class;
		[Embed(source="../assets/Chess_zlt45.png")]
		public static var IMAGE_WHITE : Class;				
		
		public function Champion()
		{
			super();
			classification = CLASSIFICATION_LEAPER;
		}
		
		public override function get pointValue() : Number {
			return 5;
		}
		
		public override function getMovementBitboard(boardPieces:Bitboard) : Bitboard {
		
			//we don't really care about out of range errors here.
			
			var bitboard : Bitboard = new Bitboard();

			//vertical orthoganal movements						
			bitboard.silentSetBitAt(
				(Piece.captureTest(rank + 1, file, boardPieces, alignment) > 0) ? 1 : 0,
				rank + 1, 
				file
			);
			
			bitboard.silentSetBitAt(
				(Piece.captureTest(rank - 1, file, boardPieces, alignment) > 0) ? 1 : 0,
				rank - 1, 
				file
			);
			
			bitboard.silentSetBitAt(
				(Piece.captureTest(rank + 2, file, boardPieces, alignment) > 0) ? 1 : 0,
				rank + 2, 
				file
			);
			
			bitboard.silentSetBitAt(
				(Piece.captureTest(rank - 2, file, boardPieces, alignment) > 0) ? 1 : 0,
				rank - 2, 
				file
			);

			//horizontal orthogonal movements
			bitboard.silentSetBitAt(
				(Piece.captureTest(rank, file + 1, boardPieces, alignment) > 0) ? 1 : 0,
				rank, 
				file + 1
			);
			
			bitboard.silentSetBitAt(
				(Piece.captureTest(rank, file - 1, boardPieces, alignment) > 0) ? 1 : 0,
				rank, 
				file - 1
			);
						
			bitboard.silentSetBitAt(
				(Piece.captureTest(rank, file + 2, boardPieces, alignment) > 0) ? 1 : 0,
				rank, 
				file + 2
			);
			
			bitboard.silentSetBitAt(
				(Piece.captureTest(rank, file - 2, boardPieces, alignment) > 0) ? 1 : 0,
				rank, 
				file - 2
			);		

			//diagonal movements
			bitboard.silentSetBitAt(
				(Piece.captureTest(rank + 2, file + 2, boardPieces, alignment) > 0) ? 1 : 0,
				rank + 2, 
				file + 2
			);
			
			bitboard.silentSetBitAt(
				(Piece.captureTest(rank - 2, file + 2, boardPieces, alignment) > 0) ? 1 : 0,
				rank - 2, 
				file + 2
			);
			
			bitboard.silentSetBitAt(
				(Piece.captureTest(rank + 2, file - 2, boardPieces, alignment) > 0) ? 1 : 0,
				rank + 2, 
				file - 2
			);		
			
			bitboard.silentSetBitAt(
				(Piece.captureTest(rank - 2, file - 2, boardPieces, alignment) > 0) ? 1 : 0,
				rank - 2, 
				file - 2
			);		
			
			return bitboard;
		}
		
		public override function getCaptureBitboard(boardPieces:Bitboard) : Bitboard {
			return getMovementBitboard(boardPieces);
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
			return alignment == Piece.ALIGNMENT_WHITE ? "C" : "c";
		}
	}
}