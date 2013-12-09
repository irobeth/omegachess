package net.omegachess.classes.pieces
{
	import flash.display.DisplayObject;
	
	import mx.controls.Image;
	
	import net.omegachess.classes.Bitboard;
	
	[RemoteClass]
	public class Pawn extends Piece
	{
		[Embed(source="../assets/Chess_pdt45.png")]
		public static var IMAGE_BLACK : Class;
		[Embed(source="../assets/Chess_plt45.png")]
		public static var IMAGE_WHITE : Class;		
		
		public function Pawn()
		{
			super();
			classification = CLASSIFICATION_RIDER;
		}
		
		public override function get pointValue() : Number {
			return 1;
		}		
		
		public override function getMovementBitboard(boardPieces:Bitboard) : Bitboard {
			
			//Debug.show(Debug.FUNCTION, "Pawn::getMovementBitboard", "");
			//Debug.show(Debug.INFO, "Pawn::gMB", "My rank is " + rank);
			//Debug.show(Debug.INFO, "Pawn::gMB", "My file is " + file);
			
			var bitboard : Bitboard = new Bitboard();
			
			switch(alignment) {
				case Piece.ALIGNMENT_WHITE :
					if(hasMoved) {
						bitboard.silentSetBitAt(1, rank + 1, file); //here we can treat pawns like 1,0 leapers	
					} else { 
						//a first-move pawn is technically a rider for 3, we need to check 
						//for pieces interrupting us here.
						for(var i : Number = 1; i <= 3; i++) {
							var occupied : Number = boardPieces.getBitAt(rank + i, file);
							
							if(occupied != 0) {
								break;
							} else {
								//things that'd set the en-passant target are marked 3
								bitboard.silentSetBitAt(i != 1 ? 3 : 1, rank + i, file);
							}
						}
					} break;
				case Piece.ALIGNMENT_BLACK :
					if(hasMoved) {
						bitboard.silentSetBitAt(1, rank - 1, file);	
					} else { 
						for(var i : Number = 1; i <= 3; i++) {
							var occupied : Number = boardPieces.getBitAt(rank - i, file);
							
							if(occupied != 0) {
								break;
							} else {
								bitboard.silentSetBitAt(i != 1 ? 3 : 1, rank - i, file);
							}
						}
					} break;					
			}

			return bitboard;
		}
		
		public override function getCaptureBitboard(boardPieces:Bitboard) : Bitboard {

			//TODO: incorporate a scan for enPassant targets here.
			
			var direction : Number = alignment == Piece.ALIGNMENT_WHITE ? 1 : -1;
			var bitboard : Bitboard = new Bitboard();
			bitboard.silentSetBitAt(1, rank + direction * 1, file + 1);
			bitboard.silentSetBitAt(1, rank + direction * 1, file - 1);
			
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
			return alignment == Piece.ALIGNMENT_WHITE ? "P" : "p";
		}
	}
}