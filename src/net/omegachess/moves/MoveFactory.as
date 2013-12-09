package net.omegachess.moves
{
	import net.omegachess.classes.Board;
	import net.omegachess.components.Cell;
	import net.omegachess.moves.generators.IMoveGenerator;

	public class MoveFactory extends Object
	{
		[ArrayElementType("Cell")]
		public static function getMoves( cell : Cell, board : Board ) : Array {
			Debug.show(Debug.INFO, "MovementController::getMovementTargets", "");
			//every piece except 
			//	pawns
			//	kings
			//	fools(possibly)
			//generate their moves with the same algorithm
			var mgf : MoveGeneratorFactory 		= new MoveGeneratorFactory();
			var moveGenerator : IMoveGenerator 	= mgf.getGenerator(cell, board);
			
			[ArrayElementType("Move")]
			var moveList : Array				= moveGenerator.getMoveset(cell, board);
			
			return moveList;
		}
	}
}