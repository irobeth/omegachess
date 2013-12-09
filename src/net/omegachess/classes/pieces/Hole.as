package net.omegachess.classes.pieces
{
	import flash.display.DisplayObject;
	
	import mx.controls.Image;
	import mx.core.IFlexDisplayObject;
	
	import net.omegachess.classes.Bitboard;
	
	[RemoteClass]
	public class Hole extends Piece
	{
		public function Hole()
		{
			super();
		}
		
		public override function get pointValue() : Number {
			return 0;
		}
				
		//teach this piece about its position
		public override function setPosition( rank : Number, file : Number ) : void {
			
		}
		
		public override function getMovementBitboard(boardPieces:Bitboard) : Bitboard {
			
		//	throw new Error("Piece requires getMovementBitboard to be overridden by a subclass of Piece");
			
			return null;
		}
		
		public override function getCaptureBitboard(boardPieces:Bitboard) : Bitboard {
			
			//throw new Error("Piece requires getCaptureBitboard to be overridden by a subclass of Piece");
			
			return null;
		}
		
		public override function getItemRenderer() : DisplayObject {
			
			var image : Image = new Image();
			image.alpha = 0;
			image.visible = false;
			image.includeInLayout = false;
			return image;
			
		}
		
		public override function acn() : String {
			return "0";
		}
	}
}