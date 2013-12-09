package net.omegachess.populators
{
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Hole;
	import net.omegachess.classes.pieces.King;
	import net.omegachess.classes.pieces.Pawn;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.components.Cell;
	
	public class PawnTestCasePopulator implements IBoardPopulator
	{
		public function PawnTestCasePopulator(){}
		
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
		
		public function getCell(cell:Cell) : Piece {
			//we need to set up a few cases
			//pawn can first move
			//pawn can capture instead
			//pawn first move also triggers en passant for the black pawn
			/**
			 * 000000000000
			 * 000000000000
			 * 000000000000
			 * 000000000000
			 * 000000000000
			 * 000000000000
			 * 000000000000
			 * 00p000000000
			 * 0P0000000000
			 * 000000000000
			 * */
			if(cell.rank == 2 && cell.file == 1) {
				//white pawn
				var p : Pawn = new Pawn();
					p.alignment = Piece.ALIGNMENT_WHITE;
					p.hasMoved	= false;
					p.setPosition(
						cell.rank, 
						cell.file
					);
				return p;
			} else if(cell.rank == 3 && cell.file == 2) {
				//black pawn
				var p : Pawn = new Pawn();
					p.alignment = Piece.ALIGNMENT_BLACK;
					p.hasMoved	= true;
					p.setPosition(
						cell.rank, 
						cell.file
					);
				return p;
			} else {
				//kings must exist in the usual places?
				if(cell.file == 6 && (cell.rank == 1 || cell.rank == 10)) {
					var k : King = new King();
					
					if(cell.rank == 1) {
						k.alignment = Piece.ALIGNMENT_WHITE;
					} else if(cell.rank == 10) {
						k.alignment = Piece.ALIGNMENT_BLACK;
					}
						k.hasMoved = true; //should short-circuit scans for castling with no rooks?
						k.setPosition(
							cell.rank,
							cell.file
						);
						
					return k;
				} else {
					var h : Hole = new Hole();
						h.alignment = Piece.ALIGNMENT_NONE;
						h.setPosition(
							cell.rank,
							cell.file
						);
						
					return h;
				}
			}			
		}
	}
}