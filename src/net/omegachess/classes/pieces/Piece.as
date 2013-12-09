package net.omegachess.classes.pieces
{
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	
	import mx.core.IFlexDisplayObject;
	
	import net.omegachess.classes.Bitboard;
	
	[RemoteClass]
	public class Piece extends Object {
		
		public static const ALIGNMENT_WHITE 		: Number = 1;		
		public static const ALIGNMENT_BLACK 		: Number = 2;
		public static const ALIGNMENT_NONE 			: Number = 0;
		public static const ALIGNMENT_HOLE 			: Number = 8;
		
		public static const CLASSIFICATION_BASE 	: Number = 0;
		public static const CLASSIFICATION_LEAPER	: Number = 1;
		public static const CLASSIFICATION_RIDER	: Number = 2;
		
		public var alignment : Number = Piece.ALIGNMENT_WHITE;
		public var hasMoved : Boolean = false;
		
		public var classification : Number = CLASSIFICATION_BASE;
		
		//let's code with support for 'Can't move into check' on pieces that aren't the king.
		//public var royalty : Boolean = false;
		
		protected var rank : Number;
		protected var file : Number;
		
		public function Piece()
		{
			super();
		}
		
		//teach this piece about its position
		public function setPosition( rank2 : Number, file2 : Number ) : void {
			this.rank = rank2;
			this.file = file2;					
		}
		
		public function get pointValue() : Number {
			
			throw new Error("Piece requires getMovementBitboard to be overridden by a subclass of Piece");
			
			return null;
		}
		
		public function getMovementBitboard(boardPieces:Bitboard) : Bitboard {
			
			throw new Error("Piece requires getMovementBitboard to be overridden by a subclass of Piece");
			
			return null;
		}
		
		public function getCaptureBitboard(boardPieces:Bitboard) : Bitboard {
			
			throw new Error("Piece requires getCaptureBitboard to be overridden by a subclass of Piece");
			
			return null;
		}
		
		public function getItemRenderer() : DisplayObject {
			
			throw new Error("Piece requires getItemRenderer to be overridden by a subclass of Piece");
			
			return null;
		}
			
		public function acn() : String {
			return "?";
		}
		
		public static function alignmentToString( alignment : Number ) : String {
			if(alignment == Piece.ALIGNMENT_BLACK){
				return "Black";
			} else if(alignment == Piece.ALIGNMENT_WHITE) {
				return "White";
			} else if(alignment == Piece.ALIGNMENT_HOLE) {
				return "Hole";
			} else if(alignment == Piece.ALIGNMENT_NONE) {
				return "None";
			} else {
				throw new IllegalOperationError("Tried to get the string representation of some unknown alignment");
			}
		}
		/**
		 * TODO: This actually limits our flexibility by making it impossible for a piece to capture
		 * its own alignment.
		 * 
		 * Decides if a piece can capture the piece at r,f
		 * 
		 * At some point consider just setting the bits in a bitboard regardless of their original occupants?
		 * */
		public static function captureTest(
			r : Number, 
			f : Number, 			
			boardPieces : Bitboard,
			alignment : Number
		) : Number {			
			Debug.show(Debug.VERBOSE_3, "Piece::captureTest", r + ", " + f);
								
			//Debug.show(Debug.VERBOSE_3, "BoardPieces", boardPieces);
			
			var bit : Number = boardPieces.silentGetBitAt(r, f);			
			Debug.show(Debug.VERBOSE_3, "CaptureTest", "Bit is " + bit);
			if(bit == Piece.ALIGNMENT_HOLE) { //board hole
				//can't move off the board
				return 0;					
			} else if(bit == Piece.ALIGNMENT_NONE) {
				//we can move here
				Debug.show(Debug.VERBOSE_3, "CaptureTest", "Returning 1");
				return 1;
			} else {
				//we need to include this if it's not our alignment, but then break
				if(alignment == Piece.ALIGNMENT_BLACK && bit == Piece.ALIGNMENT_WHITE) {
					Debug.show(Debug.VERBOSE_3, "CaptureTest", "Returning 2");
					return 2;
				} else if(alignment == Piece.ALIGNMENT_WHITE && bit == Piece.ALIGNMENT_BLACK) {
					Debug.show(Debug.VERBOSE_3, "CaptureTest", "Returning 2");
					return 2;
				} else if(alignment == bit) {
					Debug.show(Debug.VERBOSE_3, "CaptureTest", "Returning -1");
					return -1; //tried to move onto our own square.
				} else {
					throw new Error("There is no way a piece could have been marked on that board and not have an alignment.");
				}
			}				
		}
	}
}