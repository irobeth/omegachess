package net.omegachess.moves.generators
{
	import net.omegachess.classes.Bitboard;
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Hole;
	import net.omegachess.classes.pieces.Pawn;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.components.Cell;
	import net.omegachess.moves.movetypes.Capture;
	import net.omegachess.moves.movetypes.EnPassantCapture;
	import net.omegachess.moves.movetypes.Move;
	import net.omegachess.moves.movetypes.PawnFirstMove;
	import net.omegachess.moves.movetypes.StandardMove;
	import net.omegachess.rules.Check;
	import net.omegachess.rules.IOmegaChessRule;
	
	/**
	 * Consider making 'PawnFirstMove' a type of move which can alter the board state
	 * to set the en-passant targets.
	 * */ 
	public class PawnMoveGenerator implements IMoveGenerator
	{
		public function PawnMoveGenerator()
		{
		}
		
		public function getMoveset(cell:Cell, board:Board) : Array {			
			Debug.show(Debug.FUNCTION, "PawnMoveGenerator::getMoveset", "");					
			var moveset : Array = new Array();
			
			new Assertion(cell.piece is Pawn);
			
			var piecebits : Bitboard 		= board.getPiecesBitboard();
			var pawn : Piece 				= cell.piece;					
			//Debug.show(Debug.DUMP, "", pawn);
			//grab the pawn's movement bitboard
			var movebits : Bitboard 		= pawn.getMovementBitboard(piecebits);
			var capturebits : Bitboard		= pawn.getCaptureBitboard(piecebits);
			
			var unfilteredTargets : Array 	= board.getCellsFromBitboard(movebits);
			
			//movements only
			for each(var target : Cell in unfilteredTargets) {
				//compare r,f in the bitboard for whether it's a first move or not
				if(target.piece is Hole) {
					var mov : Move;
					
					if(movebits.getBitAt(target.rank, target.file) == 3) {
						mov = new PawnFirstMove();
					} else {
						mov = new StandardMove();					
					}
					
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
					//we don't care (unless it's an en passant target)
					if(board.enPassantPawn != null && board.enPassantPawn.piece.alignment == board.enemyAlignment) {
						new Assertion(board.enPassantTargets.length > 0);
						
						//is target in enPassantTargets?
						for each(var eptarget : Cell in board.enPassantTargets) {
							if(eptarget.rank == target.rank && eptarget.file == target.file) {
								cap = new EnPassantCapture();
									cap.source = cell;
									cap.destination = eptarget;
								moveset.push(cap);
							}
						}
					}
				}							
			}
					
			return moveset;
		}
	}
}