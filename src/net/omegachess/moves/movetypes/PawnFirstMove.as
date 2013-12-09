package net.omegachess.moves.movetypes
{
	import flash.errors.IllegalOperationError;
	
	import mx.collections.ArrayCollection;
	
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Hole;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.components.Cell;

	[RemoteClass]
	public class PawnFirstMove extends Move implements IMove
	{
		public function PawnFirstMove() {
			super();
		}
		
		override public function apply( board : Board ) : Board {
			//Debug.show(Debug.FUNCTION, "PFM::apply", "");
			//Debug.show(Debug.INFO, "PFM:apply", Piece.alignmentToString(board.movingAlignment) + " to move.");
			//assert destination as empty since we're not capturing			
			new Assertion(board.getCellAt(destination.rank, destination.file).piece is Hole);
			
			var workBoard : Board = board.copy();
				workBoard.toggleMovingAlignment();
				
				/**
				 * TODO: set en passant targets here
				 * */
			var workDestination : Cell = workBoard.getCellAt(destination.rank, destination.file);
								
			var workSource : Cell = workBoard.getCellAt(source.rank, source.file);
			
				workDestination.piece = workSource.piece;
				workDestination.piece.hasMoved = true;
				workSource.vacate();
			
			var workingEPTargets : ArrayCollection = new ArrayCollection();
			
			if(workDestination.piece.alignment == Piece.ALIGNMENT_WHITE) {
				for(var r : Number = workSource.rank; r < workDestination.rank; r++) {
					workingEPTargets.addItem(workBoard.getCellAt(r, workSource.file));	
				}
			} else {
				for(var r : Number = workSource.rank; r > workDestination.rank; r--) {
					workingEPTargets.addItem(workBoard.getCellAt(r, workSource.file));	
				}				
			}
			
			workBoard.enPassantTargets = workingEPTargets;
			workBoard.enPassantPawn = workDestination;
			
			//Debug.show(Debug.INFO, "PFM:apply", Piece.alignmentToString(workBoard.movingAlignment) + " to move after apply.");
			return workBoard;			
		}
		
		override public function toACN() : String {			
			return destination.toACN();
		}
	}
}