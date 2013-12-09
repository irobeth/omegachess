package net.omegachess.classes.pieces
{
	import flash.display.DisplayObject;
	
	import mx.controls.Image;
	
	import net.omegachess.classes.Bitboard;
	
	[RemoteClass]
	public class Rook extends Piece
	{
		[Embed(source="../assets/Chess_rdt45.png")]
		public static var IMAGE_BLACK : Class;
		[Embed(source="../assets/Chess_rlt45.png")]
		public static var IMAGE_WHITE : Class;		
		
		public function Rook()
		{
			super();
			classification = CLASSIFICATION_RIDER;
		}
		
		public override function get pointValue() : Number {
			return 6;
		}
				
		public override function getMovementBitboard(boardPieces:Bitboard) : Bitboard {
			var bitboard : Bitboard = new Bitboard();
			
			//scan right
			for(var o : Number = 1; file + o < 12; o ++) {				
				var val : Number = Piece.captureTest(rank, file+o, boardPieces, alignment);
				
				bitboard.setBitAt((val > 0) ? 1 : 0, rank ,file+o);
				
				if(val <= 0 || val == 2 ) {
					break;
				} 								
								
			}
			
			//scan left
			for(var o : Number = 1; file + o >= 0; o ++) {				
				var val : Number = Piece.captureTest(rank, file-o, boardPieces, alignment);
				
				bitboard.setBitAt((val > 0) ? 1 : 0, rank ,file-o);
				
				if(val <= 0 || val == 2 ) {
					break;
				} 								
 								
			}
			
			//scan up
			for(var o : Number = 1; rank + o < 12; o ++) {				
				var val : Number = Piece.captureTest(rank+o, file, boardPieces, alignment);
				
				bitboard.setBitAt((val > 0) ? 1 : 0, rank+o ,file);
				
				if(val <= 0 || val == 2 ) {
					break;
				} 								
								
			}
			
			//scan down
			for(var o : Number = 1; rank - o >= 0; o ++) {				
				var val : Number = Piece.captureTest(rank-o, file, boardPieces, alignment);
				
				bitboard.setBitAt((val > 0) ? 1 : 0, rank-o ,file);
				
				if(val <= 0 || val == 2 ) {
					break;
				} 								
								
			}
			
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
			return alignment == Piece.ALIGNMENT_WHITE ? "R" : "r";
		}
	}
}