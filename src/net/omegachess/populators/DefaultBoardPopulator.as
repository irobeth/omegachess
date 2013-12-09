package net.omegachess.populators
{
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.*;
	import net.omegachess.components.Cell;
	
	public class DefaultBoardPopulator implements IBoardPopulator
	{
		public function DefaultBoardPopulator() {
			
		}
		
		public function populate(board : Board) : void {
			for(var r : Number = 0; r < 12; r++) {
				for(var f : Number = 0; f < 12; f++) {
					//Debug.show(Debug.INFO, "Board()", "Populating "+r+", "+f);
					var c : Cell = new Cell();
					c.rank = r;
					c.file = f;							
					c.piece = getCell(c);
					
					board.setCellAt(c,r,f);
					
					if(c.piece is King) {
						switch(c.piece.alignment) {
							case Piece.ALIGNMENT_WHITE :
								board.whiteKing = c;
								break;
							case Piece.ALIGNMENT_BLACK :
								board.blackKing = c;
								break;
						}
					}					
				}
			}
		}
		public function getCell( cell : Cell ):Piece {
			var rank : Number = cell.rank;
			var file : Number = cell.file
						
			var piece : Piece;
			
			if((rank == 0 && file != 0 && file != 11) ||
				(rank == 11 && file != 0 && file != 11) ||
				(file == 0 && rank != 0 && rank != 11) || 
				(file == 11 && rank != 0 && rank != 11)) {
				piece = new Hole();
				piece.alignment = Piece.ALIGNMENT_HOLE;
			} else if(rank <=2 || rank >=9) {
				if(file == 0 || file == 11) {
					piece = new Wizard();	
				} else if(rank == 2 || rank == 9){					
					piece = new Pawn();
					//piece = new Hole();
					//piece.alignment = Piece.ALIGNMENT_NONE;
				} else if(file == 1 || file == 10) {
					piece = new Champion();				
				} else if(file == 2 || file == 9) {
					piece = new Rook();				
				} else if(file == 3 || file == 8) {
					piece = new Knight();
				} else if(file == 4 || file == 7) {
					piece = new Bishop();
				} else if(file == 6) {
					piece = new King();
				} else if(file == 5) {
					piece = new Queen();
				}
			} else {
				piece = new Hole();
				piece.alignment = Piece.ALIGNMENT_NONE;
			}
			
			if((rank < 5) && !(piece is Hole)) {
				piece.alignment = Piece.ALIGNMENT_WHITE;
			} else if((rank > 5) && !(piece is Hole)) {
				piece.alignment = Piece.ALIGNMENT_BLACK;
			}
			
			piece.setPosition(rank, file);
			
			return piece;			
		}
	}
}