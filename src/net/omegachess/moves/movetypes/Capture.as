package net.omegachess.moves.movetypes
{
	import flash.errors.IllegalOperationError;
	
	import mx.collections.ArrayCollection;
	
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Hole;
	import net.omegachess.classes.pieces.King;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.components.Cell;
	
	[RemoteClass]
	public class Capture extends Move implements IMove
	{
		public function Capture()
		{
			super();
		}
		
		override public function apply( board : Board ) : Board {
			//very similar to a standard move; however, we're going to vacate both cells and then fill the destination.			
			//Debug.show(Debug.FUNCTION, "Capture::apply", "");
			//Debug.show(Debug.INFO, "Capture:apply", Piece.alignmentToString(board.movingAlignment) + " to move.");
			
			//assert destination as occupied since we're capturing
			new Assertion(!(board.getCellAt(destination.rank, destination.file).piece is Hole));
			
			var workBoard : Board = board.copy();
			
			var workSource : Cell = workBoard.getCellAt(source.rank, source.file);
			
				var workDestination : Cell = workBoard.getCellAt(destination.rank, destination.file);
				var capturedPiece : Piece = workDestination.piece;	
					workDestination.piece = workSource.piece;
					workDestination.piece.hasMoved = true;
			
				workSource.vacate();
			
			var capturedPieces : ArrayCollection = workBoard.capturedPieces;
				capturedPieces.addItem(capturedPiece);
				
			//Debug.show(Debug.INFO, "Capture:apply", "Captured " + capturedPiece.acn());
			//Debug.show(Debug.INFO, "Capture:apply", Piece.alignmentToString(workBoard.movingAlignment) + " to move after apply.");
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
			return source.piece.acn()+source.toACN()+"x"+destination.toACN();
			//throw new IllegalOperationError("NYI");	
		}
	}
}