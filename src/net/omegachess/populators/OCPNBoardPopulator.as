package net.omegachess.populators
{
	import mx.utils.ObjectUtil;
	
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.King;
	import net.omegachess.classes.pieces.Locator;
	import net.omegachess.classes.pieces.Pawn;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.classes.pieces.Rook;
	import net.omegachess.components.Cell;
	import net.omegachess.intents.Intent;
	import net.omegachess.intents.IntentRegistry;
	
	public class OCPNBoardPopulator implements IBoardPopulator
	{
		private var ocpn : String;
		
		public function OCPNBoardPopulator(ocpn : String)
		{
			this.ocpn = ocpn;			
		}
		
		
		
		public function getCell(cell:Cell):Piece
		{
			return null;
		}
		
		public function populate(board:Board):void
		{
			var files : Array = this.ocpn.split("/");
			
			var k : Piece = Locator.GetPieceFromOCPN("C",1,1);
			
			//W3
			k = Locator.GetPieceFromOCPN(files[0].charAt(0),0,0);	
				board.getCellAt(0,0).piece = k;
			//W4
			k = Locator.GetPieceFromOCPN(files[0].charAt(1),0,0);
				board.getCellAt(0,11).piece = k;
				
			//W1
			k = Locator.GetPieceFromOCPN(files[11].charAt(0),0,0);
				board.getCellAt(11,0).piece = k;
			//W2
			k = Locator.GetPieceFromOCPN(files[11].charAt(1),0,0);
				board.getCellAt(11,11).piece = k;
			
				
			for(var r : Number = 1; r < 11; r ++) {
				for(var f : Number = 0; f < files[r].length; f ++) {								
					if(files[r].charAt(0) === "A" || files[r].charAt(0) === "a") {
						break;
					} else if(parseInt(files[r].charAt(f)) > 0) {						
						f += parseInt(files[r].charAt(f));						
					} else {
						k = Locator.GetPieceFromOCPN(files[r].charAt(f),0,0);
							board.getCellAt(r,f+1).piece = k;											
					}
				}
				
				//now a few tests to make sure things can't castle/firstmove if they shouldn't
				if(k is Pawn) {
					if(k.alignment === Piece.ALIGNMENT_WHITE && r !== 2) {
						k.hasMoved = true;
					}
					
					if(k.alignment === Piece.ALIGNMENT_BLACK && r !== 9) {
						k.hasMoved = true;
					}
				}
			}

			var file12Index : Number = 0;
			
			for(var r : Number = 0; r < 12; r ++) {
				for(var f : Number = 0; f < 12; f++) {					
					var piece : Piece = (board.getCellAt(r,f) as Cell).piece;
					if(piece is King || piece is Rook) {						
						if(files[12].charAt(file12Index) === "0") piece.hasMoved = true;
						
						file12Index++;
					}
				}
			}
			
			var i : Intent = new Intent(this);
				i.type = Intent.INTENT_TYPE_BOARD_CHANGED;
				i.data = board;
			IntentRegistry.handleIntent(i);

		}
		
		
	}
}