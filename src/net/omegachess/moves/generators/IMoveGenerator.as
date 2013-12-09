package net.omegachess.moves.generators
{
	import net.omegachess.classes.Board;
	import net.omegachess.components.Cell;

	public interface IMoveGenerator {
		
		[ArrayElementType("net.omegachess.moves.movetypes.IMove")]
		function getMoveset(cell : Cell, board : Board) : Array
	}
}