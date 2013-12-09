package net.omegachess.moves.movetypes
{
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Hole;	
	import net.omegachess.classes.pieces.Piece;	
	import net.omegachess.components.Cell;

	[RemoteClass]
	public class KingsideCastle extends Move implements IMove
	{
		public function KingsideCastle(board : Board) {
			super();
			switch(board.movingAlignment) {
				case Piece.ALIGNMENT_WHITE :
					destination = board.getCellAt(1,8);
					break;
				case Piece.ALIGNMENT_BLACK :
					destination = board.getCellAt(10,8);
					break;
			}
		}
		
		override public function apply( board : Board ) : Board {
			//standard moves are really easy; they're not captures and they're nothing special. Fill one cell, vacate the other.
			//Debug.show(Debug.FUNCTION, "KingsideCastle::apply", "");
			//Debug.show(Debug.INFO, "KC:apply", Piece.alignmentToString(board.movingAlignment) + " to move.");
			
			//assert destination as empty since we're not capturing
			new Assertion(board.getCellAt(destination.rank, destination.file).piece is Hole);
			
			var kingCell : Cell;
			var king : Piece;
			var rook : Piece;
			var rookCell : Cell;
			
			var kingTargetCell : Cell;
			var rookTargetCell : Cell;
			
			var workBoard : Board = board.copy();
				
			
			if(workBoard.movingAlignment == Piece.ALIGNMENT_BLACK) {
				//black kingside rook is at I9 (10,9)
				//black rook to G9, king to H9
				kingCell 		= workBoard.blackKing;
				king 			= workBoard.blackKing.piece;				
				
				rookCell 		= workBoard.getCellAt(10, 9);
				rook 			= rookCell.piece;
				
				rookTargetCell 	= workBoard.getCellAt(10, 7);
				kingTargetCell	= workBoard.getCellAt(10, 8);
			} else {
				//white kingside rook is at I9 (0,9)
				//white rook to G0, king to H0
				kingCell 		= workBoard.whiteKing;
				king 			= workBoard.whiteKing.piece;				
				
				rookCell 		= workBoard.getCellAt(1, 9);
				rook 			= rookCell.piece;
				
				rookTargetCell 	= workBoard.getCellAt(1, 7);
				kingTargetCell	= workBoard.getCellAt(1, 8);
			}
			
			//push rook into target cell
			rookTargetCell.piece 			= rookCell.piece;
			rookTargetCell.piece.hasMoved 	= true;
			
			//vacate rook
			rookCell.vacate();
			
			//push king into target cell
			kingTargetCell.piece 			= kingCell.piece;
			rookTargetCell.piece.hasMoved	= true;
			
			//vacate king
			kingCell.vacate();
			
			if(workBoard.movingAlignment == Piece.ALIGNMENT_BLACK) {
				workBoard.blackKing = kingTargetCell;
			} else {
				workBoard.whiteKing = kingTargetCell;
			}
			
			workBoard.toggleMovingAlignment();
			workBoard.enPassantTargets = null;
			workBoard.enPassantPawn = null;
			//Debug.show(Debug.INFO, "KingsideCastle:apply", Piece.alignmentToString(workBoard.movingAlignment) + " to move after apply.");
			return workBoard;		
		}
		
		override public function toACN() : String {
			return "0-0";
		}
	}
}