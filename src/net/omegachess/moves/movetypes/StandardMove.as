package net.omegachess.moves.movetypes
{
	import flash.errors.IllegalOperationError;
	
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Hole;
	import net.omegachess.classes.pieces.King;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.components.Cell;

	[RemoteClass]
	public class StandardMove extends Move implements IMove
	{
		public function StandardMove() {
			super();
		}
		
		override public function apply( board : Board ) : Board {
			//standard moves are really easy; they're not captures and they're nothing special. Fill one cell, vacate the other.
			//Debug.show(Debug.FUNCTION, "StandardMove::apply", "");
			//Debug.show(Debug.INFO, "SM:apply", Piece.alignmentToString(board.movingAlignment) + " to move.");
			
			//assert destination as empty since we're not capturing
			new Assertion(board.getCellAt(destination.rank, destination.file).piece is Hole);
			
			var workBoard : Board = board.copy();
			
			var workSource : Cell = workBoard.getCellAt(source.rank, source.file);

				var workDestination : Cell = workBoard.getCellAt(destination.rank, destination.file);					
					workDestination.piece = workSource.piece;
					workDestination.piece.hasMoved = true;
					
				workSource.vacate();
			
			if(workDestination.piece is King && workBoard.movingAlignment == Piece.ALIGNMENT_BLACK) {
				workBoard.blackKing = workDestination;
			} else if(workDestination.piece is King && workBoard.movingAlignment == Piece.ALIGNMENT_WHITE) {
				workBoard.whiteKing = workDestination;
			}
			
			workBoard.toggleMovingAlignment();
			workBoard.enPassantTargets = null;
			workBoard.enPassantPawn = null;
			return workBoard;		
			//throw new IllegalOperationError("NYI");
		}
		
		override public function toACN() : String {
			//figuring this out is more difficult than it seems
			//what if two of the same piece can move to the same square?
			/**
			 * TODO: update this to scan the board for duplicate pieces
			 * */
			return source.piece.acn()+source.toACN()+":"+destination.toACN();
			//throw new IllegalOperationError("NYI");	
		}
	}
}