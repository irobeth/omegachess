package net.omegachess.moves.movetypes
{
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Hole;	
	import net.omegachess.classes.pieces.Piece;	
	import net.omegachess.components.Cell;

	[RemoteClass]
	public class QueensideCastle extends Move implements IMove
	{
		public function QueensideCastle(board : Board) {
			super();
			switch(board.movingAlignment) {
				case Piece.ALIGNMENT_WHITE :
					destination = board.getCellAt(1,4);
					break;
				case Piece.ALIGNMENT_BLACK :
					destination = board.getCellAt(10,4);
					break;
			}
		}
		
		override public function apply( board : Board ) : Board {
			//standard moves are really easy; they're not captures and they're nothing special. Fill one cell, vacate the other.
			//Debug.show(Debug.FUNCTION, "QueensideCastle::apply", "");
			//Debug.show(Debug.INFO, "QC:apply", Piece.alignmentToString(board.movingAlignment) + " to move.");
			
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
				kingCell 		= workBoard.blackKing;
				king 			= workBoard.blackKing.piece;				
				
				rookCell 		= workBoard.getCellAt(10, 2);
				rook 			= rookCell.piece;
				
				rookTargetCell 	= workBoard.getCellAt(10, 5);
				kingTargetCell	= workBoard.getCellAt(10, 4);
			} else {
				kingCell 		= workBoard.whiteKing;
				king 			= workBoard.whiteKing.piece;				
				
				rookCell 		= workBoard.getCellAt(1, 2);
				rook 			= rookCell.piece;
				
				rookTargetCell 	= workBoard.getCellAt(1, 5);
				kingTargetCell	= workBoard.getCellAt(1, 4);
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
			
			workBoard.toggleMovingAlignment();
			workBoard.enPassantTargets = null;
			workBoard.enPassantPawn = null;
			//Debug.show(Debug.INFO, "QueensideCastle:apply", Piece.alignmentToString(workBoard.movingAlignment) + " to move after apply.");
			return workBoard;		
		}
		
		override public function toACN() : String {
			return "0-0-0";
		}
	}
}