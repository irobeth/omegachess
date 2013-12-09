package net.omegachess.moves
{
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Fool;
	import net.omegachess.classes.pieces.King;
	import net.omegachess.classes.pieces.Pawn;
	import net.omegachess.classes.pieces.Queen;
	import net.omegachess.components.Cell;
	import net.omegachess.moves.generators.IMoveGenerator;
	import net.omegachess.moves.generators.KingMoveGenerator;
	import net.omegachess.moves.generators.PawnMoveGenerator;
	import net.omegachess.moves.generators.StandardMoveGenerator;

	public class MoveGeneratorFactory extends Object
	{
		public function MoveGeneratorFactory() {
			super();
		}
				
		/**
		 * I wonder if here we'll need board at all?
		 * */
		public function getGenerator(cell : Cell, board : Board) : IMoveGenerator {
			Debug.show(Debug.FUNCTION, "MoveGeneratorFactory::getGenerator", "");
			if(cell.piece is Pawn) {
				Debug.show(Debug.INFO, "MGF::getGenerator", "Cell is pawn");
				return new PawnMoveGenerator();
			} else if(cell.piece is King) {
				Debug.show(Debug.INFO, "MGF::getGenerator", "Cell is king");
				return new KingMoveGenerator();
			//} else if(cell.piece is Queen) { //guarding			
			} else if(cell.piece is Fool) {
				//NYI, fool will be weird
			}
			
			//throw new Error("Not done!");
			Debug.show(Debug.INFO, "MGF::getGenerator", "Standard move generator");
			return new StandardMoveGenerator();
		}
	}
}