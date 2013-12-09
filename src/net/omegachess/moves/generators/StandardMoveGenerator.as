package net.omegachess.moves.generators
{
	import net.omegachess.classes.Bitboard;
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Hole;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.components.Cell;
	import net.omegachess.moves.movetypes.Capture;
	import net.omegachess.moves.movetypes.Move;
	import net.omegachess.moves.movetypes.StandardMove;
	
	public class StandardMoveGenerator implements IMoveGenerator
	{
		public function StandardMoveGenerator() {
			
		}
		
		[ArrayElementType("Move")]
		public function getMoveset(cell:Cell, board:Board) : Array {
			Debug.show(Debug.FUNCTION, "StandardMoveGenerator::getMoveset", "");					
			var moveset : Array = new Array();
			
			//new Assertion(cell.piece is Pawn);
			
			var piecebits : Bitboard 		= board.getPiecesBitboard();
			var piece : Piece 				= cell.piece;					
			//Debug.show(Debug.DUMP, "", pawn);			
			var movebits : Bitboard 		= piece.getMovementBitboard(piecebits);
			var capturebits : Bitboard		= piece.getCaptureBitboard(piecebits);
			
			var unfilteredTargets : Array 	= board.getCellsFromBitboard(movebits);
			
			//movements only
			for each(var target : Cell in unfilteredTargets) {
				//compare r,f in the bitboard for whether it's a first move or not
				if(target.piece is Hole) {
					var mov : Move;
						mov = new StandardMove();					
						mov.source = cell;
						mov.destination = target;
					moveset.push(mov);
				}
			}
			
			//captures
			unfilteredTargets = board.getCellsFromBitboard(capturebits);			
			for each(var target : Cell in unfilteredTargets) {
				//here, we need only to check if target is occupied by an enemy piece.
				var cap : Move;
				
				if(target.piece.alignment == board.enemyAlignment) {
					cap = new Capture();
					cap.source = cell;
					cap.destination = target;
					moveset.push(cap);
				} else {
					//we don't care (no piece can capture friendly pieces yet)
				}							
			}			
			
			return moveset;	
		}//getMoveset
	}//class
}//package