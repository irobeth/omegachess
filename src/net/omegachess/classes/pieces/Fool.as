package net.omegachess.classes.pieces
{
	import flash.display.DisplayObject;
	
	import mx.controls.Image;
	
	import net.omegachess.classes.Bitboard;
	
	[RemoteClass]
	public class Fool extends Piece
	{
		[Embed(source="../assets/Chess_pdt45.png")]
		public static var IMAGE_BLACK : Class;
		[Embed(source="../assets/Chess_plt45.png")]
		public static var IMAGE_WHITE : Class;		
		
		private var _identity : Piece = null;
		
		public function Fool()
		{
			super();
		}
				
		public override function getMovementBitboard(boardPieces:Bitboard) : Bitboard {
			_identity.setPosition(this.rank, this.file);
			
			return _identity.getMovementBitboard(boardPieces);
		}
		
		public override function getCaptureBitboard(boardPieces:Bitboard) : Bitboard {
			
			_identity.setPosition(this.rank, this.file);
			
			return _identity.getCaptureBitboard(boardPieces);
			
		}
		
		public override function getItemRenderer() : DisplayObject {
			
			return _identity.getItemRenderer();
			
		}
		
		public override function acn() : String {
			return alignment == Piece.ALIGNMENT_WHITE ? "Z" : "z";
		}
	}
}