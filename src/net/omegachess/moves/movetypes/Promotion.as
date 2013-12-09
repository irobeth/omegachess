package net.omegachess.moves.movetypes
{
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Hole;
	import net.omegachess.classes.pieces.Pawn;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.components.Cell;

	public class Promotion extends Move
	{
		public function Promotion()
		{
			super();
		}
		
		override public function apply( board : Board ) : Board {
			trace("promotion!");
			new Assertion(_data != null && _data is Piece);
			new Assertion(_source.piece is Pawn);
	
			var predecessorMove : Move = null;
			if(_destination.piece is Hole) {
				predecessorMove = new StandardMove();
			} else {
				predecessorMove	= new Capture();
			}
				
				predecessorMove.source 			= _source;
				predecessorMove.destination 	= _destination;
				
			var workBoard : Board = predecessorMove.apply(board);
				
			trace("Work board original move played...");
			trace(workBoard.toString());
			trace(workBoard.toOCPN());
			
			var promotingAlignment = workBoard.getCellAt(_destination.rank, _destination.file).piece.alignment;
			
				//replace dest with _data
				workBoard.getCellAt(_destination.rank, _destination.file).piece 			= _data as Piece;
				workBoard.getCellAt(_destination.rank, _destination.file).piece.alignment 	= promotingAlignment;
				workBoard.getCellAt(_destination.rank, _destination.file).piece.hasMoved 	= false;
			
				trace("Work board promotion to " + (_data as Piece).acn());
				trace(workBoard.toString());
				trace(workBoard.toOCPN());
			return workBoard;		
		}
		
		override public function toACN() : String {
			return source.piece.acn()+source.toACN()+":"+destination.toACN() + "=" + (_data as Piece).acn();
		}
	}
}