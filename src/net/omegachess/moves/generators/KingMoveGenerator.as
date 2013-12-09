package net.omegachess.moves.generators
{
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.King;
	import net.omegachess.components.Cell;
	import net.omegachess.moves.movetypes.KingsideCastle;
	import net.omegachess.moves.movetypes.QueensideCastle;
	import net.omegachess.rules.CanCastleKingside;
	import net.omegachess.rules.CanCastleQueenside;
	import net.omegachess.rules.Check;
	
	public class KingMoveGenerator implements IMoveGenerator
	{
		public function KingMoveGenerator() {
			
		}
		
		public function getMoveset(cell:Cell, board:Board) : Array {
			//should determine if you can castle or not and return both castle moves and normal moves			
			Debug.show(Debug.INFO, "KingMoveGenerator::getMoveset", "");
			new Assertion(cell.piece is King);
						
			//of interest, we can piggyback off the standardMoveGenerator here, 
			//but not for pawns (because first move is weird and they can capture en passant)
			var smg : StandardMoveGenerator 	= new StandardMoveGenerator();
			var moveset : Array 				= smg.getMoveset(cell, board);
			
			//can't castle out of check
			var check : Check = new Check();
			
			if(!check.satisfies(board)) {
				var canCastleKingside : CanCastleKingside = new CanCastleKingside();
				if(canCastleKingside.satisfies(board)) {
					moveset.push(new KingsideCastle(board));
				}
	
				var canCastleQueenside : CanCastleQueenside = new CanCastleQueenside();
				if(canCastleQueenside.satisfies(board)) {
					moveset.push(new QueensideCastle(board));
				}
			}
			
			return moveset;
		}
	}
}